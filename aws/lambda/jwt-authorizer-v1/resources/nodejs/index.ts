import {JwtRsaVerifier} from "aws-jwt-verify/jwt-rsa";
import {JwtPayload} from "aws-jwt-verify/jwt-model";
import {
    APIGatewayRequestAuthorizerWithContextHandler,
    APIGatewayRequestAuthorizerEvent,
    APIGatewayAuthorizerWithContextResult
} from "aws-lambda";
import {validateCognitoJwtFields} from "aws-jwt-verify/cognito-verifier";

interface JwtSources {
    headerName: string | undefined
    cookieRegex: RegExp | undefined
}

interface RequestCookie {
    name: string,
    value: string
}

const getJwtSourcesFromEnv = (): JwtSources => {
    return {
        headerName: process.env.JWT_SOURCE_HEADER_NAME,
        cookieRegex: process.env.JWT_SOURCE_COOKIE_REGEX ? RegExp(process.env.JWT_SOURCE_COOKIE_REGEX) : undefined
    };
}

class JwtExtractor {
    sources: JwtSources

    private constructor(sources: JwtSources) {
        this.sources = sources
    }

    static createFromEnv(): JwtExtractor {
        return new JwtExtractor(getJwtSourcesFromEnv())
    }

    extractFrom(event: APIGatewayRequestAuthorizerEvent): string | undefined {
        if (this.sources.headerName !== undefined) {
            const jwtFromHeader = event.headers[this.sources.headerName]?.replace("Bearer ", "")

            if (jwtFromHeader !== undefined) {
                console.log(`Found JWT from header: ${this.sources.headerName}.`)
                return jwtFromHeader
            }
        }

        if (this.sources.cookieRegex !== undefined) {
            const jwtFromCookie = this.extractFromCookie(event)

            if (jwtFromCookie !== undefined) {
                console.log(`Found JWT from cookie: ${jwtFromCookie.name}.`)
                return jwtFromCookie.value
            }
        }

        console.log(`Could not find any JWT from header ${this.sources.headerName} or cookie matching regex ${this.sources.cookieRegex.source}.`)
        return undefined
    }

    private extractFromCookie(event: APIGatewayRequestAuthorizerEvent): RequestCookie | undefined {
        return this.extractCookies(event)
            .find((cookie) => this.sources.cookieRegex.test(cookie.name))
    }

    private extractCookies(event: APIGatewayRequestAuthorizerEvent): Array<RequestCookie> {
        return event.headers["cookie"]
                ?.split("; ")
                ?.map((value) => {
                    const split = value.split("=")
                    return {
                        name: split[0],
                        value: split[1]
                    }
                })
            ?? [];
    }
}

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

export const handler: APIGatewayRequestAuthorizerWithContextHandler<JwtPayload> = async event => {
    const jwt = jwtExtractor.extractFrom(event)

    if (jwt === undefined) {
        throw new Error("Unauthorized");
    }

    try {
        // If the token is not valid, an error is thrown:
        const verifiedJwt = await jwtVerifier.verify(jwt);
        console.log(JSON.stringify(verifiedJwt))
        return authorizedResult(event, verifiedJwt)
    } catch (error) {
        console.error("Invalid JWT:", error.message)
        throw new Error("Unauthorized");
    }
};

function authorizedResult(event: APIGatewayRequestAuthorizerEvent, jwt: JwtPayload): APIGatewayAuthorizerWithContextResult<JwtPayload> {
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
        context: jwt,
        usageIdentifierKey: jwt.sub
    }
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
