import {
    S3Client,
    WriteGetObjectResponseCommand
} from "@aws-sdk/client-s3"
import {S3ObjectEventHandler} from "./s3-object";

import axios, {AxiosResponse} from "axios";
import sharp, {Sharp} from "sharp";

import crypto from "crypto";

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
        console.debug(JSON.stringify(originalImageResponse))
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

    const originalImage: Sharp = sharp(originalImageResponse.data as Buffer)
    const originalImageContentType = originalImageResponse.headers["Content-Type"]!!.toString()
    const originalImageMetadata = await originalImage.metadata()

    const processedImage = await originalImage
        .resize(width, height, {fit: fit})
        .toFormat(originalImageMetadata.format!!, {quality: quality})
        .toBuffer()

    await s3Client.send(
        new WriteGetObjectResponseCommand({
            StatusCode: 200,
            RequestRoute: event.getObjectContext.outputRoute,
            RequestToken: event.getObjectContext.outputToken,
            Body: processedImage,
            ContentType: originalImageContentType,
            CacheControl: IMAGE_CACHE_CONTROL,
            ETag: `W/"${md5(processedImage)}"`
        })
    )

    return
}

const md5 = (buffer: Buffer): string =>
    crypto.createHash("md5").update(buffer).digest("hex")
