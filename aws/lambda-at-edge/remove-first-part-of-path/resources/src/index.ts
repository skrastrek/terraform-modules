import {CloudFrontRequestHandler} from "aws-lambda";

export const handler: CloudFrontRequestHandler = async event => {
    const request = event.Records[0].cf.request;

    if (request.uri.indexOf("/", 1) < 0) {
        request.uri = "/"
    } else {
        request.uri = request.uri.replace(/^\/[^\/]+\//, '/');
    }

    return request
};
