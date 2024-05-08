import {APIGatewayRequestAuthorizerEvent, APIGatewayRequestAuthorizerEventV2} from "aws-lambda";
import {APIGatewayRequestAuthorizerEventHeaders} from "aws-lambda/trigger/api-gateway-authorizer";

export interface JwtSources {
    headerName: string | undefined
    cookieRegex: RegExp | undefined
}

export const getJwtSourcesFromEnv = (): JwtSources => {
    return {
        headerName: process.env.JWT_SOURCE_HEADER_NAME,
        cookieRegex: process.env.JWT_SOURCE_COOKIE_REGEX ? RegExp(process.env.JWT_SOURCE_COOKIE_REGEX) : undefined
    };
}

export interface RequestCookie {
    name: string,
    value: string
}

export class JwtExtractor {
    sources: JwtSources

    private constructor(sources: JwtSources) {
        this.sources = sources
    }

    static createFromEnv(): JwtExtractor {
        return new JwtExtractor(getJwtSourcesFromEnv())
    }

    extractFromAuthorizerEventV1 = (event: APIGatewayRequestAuthorizerEvent): string | undefined => {
        if (this.sources.headerName !== undefined) {
            const jwtFromHeader = this.extractJwtFromHeaders(this.sources.headerName, event.headers)

            if (jwtFromHeader !== undefined) {
                console.debug(`Found JWT from header: ${this.sources.headerName}.`)
                return jwtFromHeader
            }
        }

        if (this.sources.cookieRegex !== undefined) {
            const jwtFromCookie = this.extractCookiesFromAuthorizerEventV1(event)

            if (jwtFromCookie !== undefined) {
                console.debug(`Found JWT from cookie: ${jwtFromCookie.name}.`)
                return jwtFromCookie.value
            }
        }

        console.log(`Could not find any JWT from header ${this.sources.headerName} or cookie matching regex ${this.sources.cookieRegex.source}.`)
        return undefined
    };

    extractFromAuthorizerEventV2 = (event: APIGatewayRequestAuthorizerEventV2): string | undefined => {
        if (this.sources.headerName !== undefined) {
            const jwtFromHeader = this.extractJwtFromHeaders(this.sources.headerName.toLowerCase(), event.headers)

            if (jwtFromHeader !== undefined) {
                console.debug(`Found JWT from header: ${this.sources.headerName}.`)
                return jwtFromHeader
            }
        }

        if (this.sources.cookieRegex !== undefined) {
            const jwtFromCookie = this.extractCookiesFromAuthorizerEventV2(event)

            if (jwtFromCookie !== undefined) {
                console.debug(`Found JWT from cookie: ${jwtFromCookie.name}.`)
                return jwtFromCookie.value
            }
        }

        console.log(`Could not find any JWT from header ${this.sources.headerName} or cookie matching regex ${this.sources.cookieRegex.source}.`)
        return undefined
    };

    private extractJwtFromHeaders = (jwtHeaderName: string, headers: APIGatewayRequestAuthorizerEventHeaders): string | undefined =>
        headers[jwtHeaderName]?.replace("Bearer ", "");

    private extractCookiesFromAuthorizerEventV1 = (event: APIGatewayRequestAuthorizerEvent): RequestCookie | undefined =>
        this.extractJwtFromCookies(event.headers["cookie"]?.split("; ") ?? []);

    private extractCookiesFromAuthorizerEventV2 = (event: APIGatewayRequestAuthorizerEventV2): RequestCookie | undefined =>
        this.extractJwtFromCookies(event.cookies ?? []);

    private extractJwtFromCookies = (cookies: string[]): RequestCookie | undefined =>
        cookies
            .map((value) => {
                const split = value.split("=")
                return {
                    name: split[0],
                    value: split[1]
                }
            })
            .find((cookie) => this.sources.cookieRegex.test(cookie.name));
}
