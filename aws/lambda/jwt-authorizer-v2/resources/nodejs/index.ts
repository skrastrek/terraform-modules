import {JwtRsaVerifier} from "aws-jwt-verify/jwt-rsa";
import {JwtPayload} from "aws-jwt-verify/jwt-model";
import {
    APIGatewayRequestSimpleAuthorizerHandlerV2WithContext,
    APIGatewayRequestAuthorizerEventV2,
    APIGatewaySimpleAuthorizerWithContextResult
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

    extractFrom(event: APIGatewayRequestAuthorizerEventV2): string | undefined {
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

    private extractFromCookie(event: APIGatewayRequestAuthorizerEventV2): RequestCookie | undefined {
        return this.extractCookies(event)
            .find((cookie) => this.sources.cookieRegex.test(cookie.name))
    }

    private extractCookies(event: APIGatewayRequestAuthorizerEventV2): Array<RequestCookie> {
        return event.cookies
            .map((value) => {
                const split = value.split("=")
                return {
                    name: split[0],
                    value: split[1]
                }
            })
    }
}

const jwtExtractor = JwtExtractor.createFromEnv()

const jwtVerifier = JwtRsaVerifier.create([
    {
        issuer: process.env.JWT_ISSUER,
        audience: process.env.JWT_AUDIENCE?.split(","),
        scope: process.env.JWT_SCOPE,
        customJwtCheck: ({payload}) =>
            validateCognitoJwtFields(payload, {
                tokenUse: validateTokenUse(process.env.JWT_COGNITO_TOKEN_USE),
                clientId: process.env.JWT_COGNITO_CLIENT_ID?.split(","),
                groups: process.env.JWT_COGNITO_GROUP?.split(",")
            }),
    },
]);

export const handler: APIGatewayRequestSimpleAuthorizerHandlerV2WithContext<JwtPayload> = async event => {
    const jwt = jwtExtractor.extractFrom(event)

    if (jwt === undefined) {
        throw new Error("Unauthorized");
    }

    try {
        // If the token is not valid, an error is thrown:
        const verifiedJwt = await jwtVerifier.verify(jwt);
        console.log(JSON.stringify(verifiedJwt))
        return authorizedResult(verifiedJwt)
    } catch (error) {
        console.error("Invalid JWT:", error.message)
        return unauthorizedResult()
    }
};

function unauthorizedResult(): APIGatewaySimpleAuthorizerWithContextResult<JwtPayload> {
    return {
        isAuthorized: false,
        context: undefined
    }
}

function authorizedResult(jwt: JwtPayload): APIGatewaySimpleAuthorizerWithContextResult<JwtPayload> {
    return {
        isAuthorized: true,
        context: jwt
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
