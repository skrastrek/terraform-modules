import {JwtRsaVerifier} from "aws-jwt-verify/jwt-rsa";
import {JwtPayload} from "aws-jwt-verify/jwt-model";
import {
    APIGatewayAuthorizerWithContextResult,
    APIGatewayRequestAuthorizerEvent,
    APIGatewayRequestAuthorizerWithContextHandler,
    APIGatewayRequestSimpleAuthorizerHandlerV2WithContext,
    APIGatewaySimpleAuthorizerWithContextResult
} from "aws-lambda";
import {validateCognitoJwtFields} from "aws-jwt-verify/cognito-verifier";
import {
    CognitoIdentityProviderClient,
    GetUserCommand,
    GetUserCommandOutput
} from "@aws-sdk/client-cognito-identity-provider";
import {JwtExtractor} from "./jwt-extractor";

type AuthContextV1 = { [key: string]: boolean | number | string }
type AuthContextV2 = { [key: string]: boolean | number | string | string[] }

const cognitoIdentityProviderClient = new CognitoIdentityProviderClient()

const jwtExtractor = JwtExtractor.createFromEnv()

const jwtVerifier = JwtRsaVerifier.create([
    {
        issuer: process.env.JWT_ISSUER,
        audience: process.env.JWT_AUDIENCE?.split(",") ?? null,
        scope: process.env.JWT_SCOPE,
        customJwtCheck: ({payload}) =>
            validateCognitoJwtFields(payload, {
                tokenUse: validateTokenUse(process.env.JWT_COGNITO_TOKEN_USE) ?? null,
                clientId: process.env.JWT_COGNITO_CLIENT_ID?.split(",") ?? null,
                groups: process.env.JWT_COGNITO_GROUP?.split(",") ?? null
            }),
    },
]);



export const handlerV1: APIGatewayRequestAuthorizerWithContextHandler<AuthContextV1> = async event => {
    const jwt = jwtExtractor.extractFromAuthorizerEventV1(event)

    if (jwt === undefined) {
        throw new Error("Unauthorized");
    }

    let verifiedJwt: JwtPayload
    try {
        // If the token is not valid, an error is thrown:
        verifiedJwt = await jwtVerifier.verify(jwt);
    } catch (error) {
        console.error("Invalid JWT:", error.message)
        throw new Error("Unauthorized");
    }

    // Enrich context with user attributes from AWS Cognito
    if (isIssuedByAwsCognito(verifiedJwt.iss) && isAccessToken(verifiedJwt)) {
        let userData: GetUserCommandOutput
        try {
            // Get user data from verified jwt:
            userData = await getUserData(jwt);
        } catch (error) {
            console.error("Could not get user data:", error.message)
            return authorizerWithContextResult(event, verifiedJwt)
        }

        return authorizerWithContextResult(event, verifiedJwt, userData)
    }

    return authorizerWithContextResult(event, verifiedJwt)
};

export const handlerV2: APIGatewayRequestSimpleAuthorizerHandlerV2WithContext<AuthContextV2> = async event => {
    const jwt = jwtExtractor.extractFromAuthorizerEventV2(event)

    if (jwt === undefined) {
        throw new Error("Unauthorized");
    }

    let verifiedJwt: JwtPayload
    try {
        // If the token is not valid, an error is thrown:
        verifiedJwt = await jwtVerifier.verify(jwt);
    } catch (error) {
        console.error("Invalid JWT:", error.message)
        return unauthorizedResult()
    }

    // Enrich context with user attributes from AWS Cognito
    if (isIssuedByAwsCognito(verifiedJwt.iss) && isAccessToken(verifiedJwt)) {
        let userData: GetUserCommandOutput
        try {
            // Get user data from verified jwt:
            userData = await getUserData(jwt);
        } catch (error) {
            console.error("Could not get user data:", error.message)
            return simpleAuthorizerWithContextResult(verifiedJwt)
        }

        return simpleAuthorizerWithContextResult(verifiedJwt, userData)
    }

    return simpleAuthorizerWithContextResult(verifiedJwt)
};

function unauthorizedResult(): APIGatewaySimpleAuthorizerWithContextResult<AuthContextV2> {
    return {
        isAuthorized: false,
        context: undefined
    }
}

function authorizerWithContextResult(event: APIGatewayRequestAuthorizerEvent, jwt: JwtPayload, userData?: GetUserCommandOutput): APIGatewayAuthorizerWithContextResult<AuthContextV1> {
    return {
        principalId: jwt.sub,
        policyDocument: {
            Version: "2012-10-17",
            Statement: [
                {
                    Action: "execute-api:Invoke",
                    Effect: "Allow",
                    Resource: event.methodArn
                }
            ]
        },
        context: {
            exp: jwt.exp,
            iss: jwt.iss,
            sub: jwt.sub,
            aud: jwt.aud.toString(),
            nbf: jwt.nbf,
            iat: jwt.iat,
            scope: jwt.scope,
            jti: jwt.jti,
            ...userAttributes(userData)
        },
        usageIdentifierKey: jwt.sub
    }
}

function simpleAuthorizerWithContextResult(jwt: JwtPayload, userData?: GetUserCommandOutput): APIGatewaySimpleAuthorizerWithContextResult<AuthContextV2> {
    return {
        isAuthorized: true,
        context: {
            exp: jwt.exp,
            iss: jwt.iss,
            sub: jwt.sub,
            aud: jwt.aud.toString(),
            nbf: jwt.nbf,
            iat: jwt.iat,
            scope: jwt.scope,
            jti: jwt.jti,
            ...userAttributes(userData)
        }
    }
}

function isIssuedByAwsCognito(iss?: string): boolean {
    if (iss !== undefined) {
        if (iss.startsWith("https://cognito-idp.") && iss.includes("amazonaws.com")) {
            return true
        }
    }

    return false
}

function isAccessToken(jwt: JwtPayload): boolean {
    return jwt.token_use === "access"
}

function userAttributes(userData?: GetUserCommandOutput): { [key: string]: string } {
    return userData?.UserAttributes?.reduce((result, curr) => ({...result, [curr.Name]: curr.Value}), {}) ?? {}
}

function validateTokenUse(value?: string) {
    if (isTokenUse(value)) {
        return value
    } else {
        throw new Error(`Invalid token use: ${value}`);
    }
}

function isTokenUse(value?: string): value is "id" | "access" | undefined {
    switch (value) {
        case "id":
        case "access":
        case undefined:
            return true
        default:
            return false
    }
}

function getUserData(accessToken: string): Promise<GetUserCommandOutput> {
    return cognitoIdentityProviderClient.send(
        new GetUserCommand({
            AccessToken: accessToken
        })
    )
}
