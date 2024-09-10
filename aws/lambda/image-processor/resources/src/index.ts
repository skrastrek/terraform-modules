import {
  S3Client,
  WriteGetObjectResponseCommand
} from "@aws-sdk/client-s3"
import {S3ObjectEventHandler} from "./s3-object";

import axios, {AxiosResponse} from "axios";
import Jimp from "jimp";

type ImageFit = "cover" | "inside" | "outside"

const DEFAULT_IMAGE_FIT: ImageFit = process.env.DEFAULT_IMAGE_FIT as ImageFit
const DEFAULT_IMAGE_QUALITY: number = Number(process.env.DEFAULT_IMAGE_QUALITY)

const IMAGE_CACHE_CONTROL = process.env.IMAGE_CACHE_CONTROL!!

const QUERY_PARAM_FIT = process.env.QUERY_PARAM_FIT!!
const QUERY_PARAM_WIDTH = process.env.QUERY_PARAM_WIDTH!!
const QUERY_PARAM_HEIGHT = process.env.QUERY_PARAM_HEIGHT!!
const QUERY_PARAM_QUALITY = process.env.QUERY_PARAM_QUALITY!!

const s3Client = new S3Client()

export const handler: S3ObjectEventHandler = async event => {
  console.debug("Event:", JSON.stringify(event))

  const params: URLSearchParams = new URL(event.userRequest.url).searchParams

  const fit: ImageFit = params.has(QUERY_PARAM_FIT) ? params.get(QUERY_PARAM_FIT) as ImageFit : DEFAULT_IMAGE_FIT
  const width: number | undefined = params.has(QUERY_PARAM_WIDTH) ? Number(params.get(QUERY_PARAM_WIDTH)) : undefined
  const height: number | undefined = params.has(QUERY_PARAM_HEIGHT) ? Number(params.get(QUERY_PARAM_HEIGHT)) : undefined
  const quality: number = params.has(QUERY_PARAM_QUALITY) ? Number(params.get(QUERY_PARAM_QUALITY)) : DEFAULT_IMAGE_QUALITY

  let originalImageResponse: AxiosResponse

  try {
    originalImageResponse = await axios.get(event.getObjectContext.inputS3Url, {responseType: 'arraybuffer'})
  } catch (error) {
    console.warn(JSON.stringify(error.toJSON()))
    if (error.response?.status === 403 || error.response?.status === 404) {
      await s3Client.send(
        new WriteGetObjectResponseCommand({
          StatusCode: 404,
          RequestRoute: event.getObjectContext.outputRoute,
          RequestToken: event.getObjectContext.outputToken,
        })
      )
    } else {
      await s3Client.send(
        new WriteGetObjectResponseCommand({
          StatusCode: 500,
          RequestRoute: event.getObjectContext.outputRoute,
          RequestToken: event.getObjectContext.outputToken,
        })
      )
    }
    return
  }

  const originalImage: Jimp = await Jimp.read(originalImageResponse.data as Buffer)
  const processedImage: Jimp = resizeImage(originalImage, fit, width, height).quality(quality)

  await s3Client.send(
    new WriteGetObjectResponseCommand({
      StatusCode: 200,
      RequestRoute: event.getObjectContext.outputRoute,
      RequestToken: event.getObjectContext.outputToken,
      Body: await processedImage.getBufferAsync(processedImage.getMIME()),
      ContentType: processedImage.getMIME(),
      CacheControl: IMAGE_CACHE_CONTROL,
      ETag: `W/"${processedImage.hash()}"`
    })
  )

  return
}

const resizeImage = (image: Jimp, fit: ImageFit, width?: number, height?: number): Jimp => {

  // No need to resize when width and height is undefined.
  if (width === undefined && height === undefined) {
    return image
  }

  // Both width and height is defined.
  else if (width !== undefined && height !== undefined) {
    switch (fit) {
      case "inside":
        return image.scaleToFit(width, height)
      case "outside":
        return image.getWidth() > image.getHeight() ? image.resize(Jimp.AUTO, height) : image.resize(width, Jimp.AUTO)
      case "cover":
        return image.cover(width, height)
      default:
        throw new Error(`Unknown image fit: ${fit}`)
    }
  }

  // Only one of width and height is defined.
  else {
    return image.resize(width ?? Jimp.AUTO, height ?? Jimp.AUTO)
  }
}
