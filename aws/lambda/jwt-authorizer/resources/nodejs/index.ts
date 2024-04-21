import {JwtRsaVerifier} from "aws-jwt-verify/jwt-rsa";
import {JwtPayload} from "aws-jwt-verify/jwt-model";
import {
    APIGatewayRequestAuthorizerHandler,
    APIGatewayRequestAuthorizerEvent,
    APIGatewayAuthorizerResult
} from "aws-lambda";

interface JwtSources {
    headerName: string | undefined
    cookieRegex: RegExp | undefined
}

interface CookieRequest {
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

    private constructor(config: JwtSources) {
        this.sources = config
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

    private extractFromCookie(event: APIGatewayRequestAuthorizerEvent): CookieRequest | undefined {
        return this.extractCookies(event)
            .find((cookie) => this.sources.cookieRegex.test(cookie.name))
    }

    private extractCookies(event: APIGatewayRequestAuthorizerEvent): Array<CookieRequest> {
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
        audience: process.env.JWT_AUDIENCE,
        scope: process.env.JWT_SCOPE
    },
]);

function unauthorizedResult(event: APIGatewayRequestAuthorizerEvent): APIGatewayAuthorizerResult {
    return {
        principalId: "unknown",
        policyDocument: {
            Version: "2012-10-17",
            Statement: [
                {
                    Action: "execute-api:Invoke",
                    Effect: "Deny",
                    Resource: event.methodArn
                }
            ]
        },
        usageIdentifierKey: undefined
    }
}

function authorizedResult(event: APIGatewayRequestAuthorizerEvent, jwt: JwtPayload): APIGatewayAuthorizerResult {
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
            iat: jwt.iat,
            iss: jwt.iss,
            jti: jwt.jti,
            nbf: jwt.nbf,
            scope: jwt.scope,
            sub: jwt.sub
        },
        usageIdentifierKey: jwt.sub
    }
}

export const handler: APIGatewayRequestAuthorizerHandler = async event => {
    const jwt = jwtExtractor.extractFrom(event)

    if (jwt === undefined) {
        throw new Error("Unauthorized");
    }

    try {
        // If the token is not valid, an error is thrown:
        const verifiedJwt = await jwtVerifier.verify(jwt);
        console.log(JSON.stringify(verifiedJwt))
        return authorizedResult(event, verifiedJwt)
    } catch {
        throw new Error("Unauthorized");
    }
};
