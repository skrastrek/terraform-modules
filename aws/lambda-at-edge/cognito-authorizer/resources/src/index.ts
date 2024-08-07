import {SecretsManagerClient, GetSecretValueCommand} from "@aws-sdk/client-secrets-manager";
import {CloudFrontRequestHandler} from "aws-lambda";
import {Authenticator} from "cognito-at-edge";

const secretsManagerClient = new SecretsManagerClient({ region: 'us-east-1' });
const authenticatorPromise = secretsManagerClient
    .send(new GetSecretValueCommand({ SecretId: process.env.AWS_LAMBDA_FUNCTION_NAME!!.replace("us-east-1.", "").concat("/config") }))
    .then(config => new Authenticator({ ...JSON.parse(config.SecretString!), logLevel: 'info' }));

export const handler: CloudFrontRequestHandler = async event => {
    try {
        const authenticator = await authenticatorPromise;
        return await authenticator.handle(event);
    } catch (error) {
        console.error(error);
        return { body: '401 Unauthorised', status: '401' };
    }
};
