import {APIGatewayRequestAuthorizerEvent, APIGatewayRequestAuthorizerEventV2} from "aws-lambda"
import {APIGatewayRequestAuthorizerEventHeaders} from "aws-lambda/trigger/api-gateway-authorizer"
import {JwtSources} from "./sources";
import {RequestCookie} from "../types";

export interface JwtExtractor<E> {
    extract(event: E): string | undefined
}

export class AuthorizerEventV1JwtExtractor implements JwtExtractor<APIGatewayRequestAuthorizerEvent> {

    constructor(public sources: JwtSources) {
    }

    extract(event: APIGatewayRequestAuthorizerEvent): string | undefined {
        if (this.sources.headerName !== undefined) {
            const jwtFromHeader = extractJwtFromHeaders(event.headers ?? {}, this.sources.headerName)

            if (jwtFromHeader !== undefined) {
                console.debug(`Found JWT from header: ${this.sources.headerName}.`)
                return jwtFromHeader
            }
        }

        if (this.sources.cookieRegex !== undefined) {
            const jwtFromCookie = findFirstCookieMatching((event.headers ?? {})["cookie"]?.split("; ") ?? [], this.sources.cookieRegex)

            if (jwtFromCookie !== undefined) {
                console.debug(`Found JWT from cookie: ${jwtFromCookie.name}.`)
                return jwtFromCookie.value
            }
        }

        console.log(`Could not find any JWT from header ${this.sources.headerName} or cookie matching regex ${this.sources.cookieRegex?.source}.`)
        return undefined
    }
}

export class AuthorizerEventV2JwtExtractor implements JwtExtractor<APIGatewayRequestAuthorizerEventV2> {

    constructor(public sources: JwtSources) {
    }

    extract(event: APIGatewayRequestAuthorizerEventV2): string | undefined {
        if (this.sources.headerName !== undefined) {
            const jwtFromHeader = extractJwtFromHeaders(event.headers ?? {}, this.sources.headerName.toLowerCase())

            if (jwtFromHeader !== undefined) {
                console.debug(`Found JWT from header: ${this.sources.headerName}.`)
                return jwtFromHeader
            }
        }

        if (this.sources.cookieRegex !== undefined) {
            const jwtFromCookie = findFirstCookieMatching(event.cookies ?? [], this.sources.cookieRegex)

            if (jwtFromCookie !== undefined) {
                console.debug(`Found JWT from cookie: ${jwtFromCookie.name}.`)
                return jwtFromCookie.value
            }
        }

        console.log(`Could not find any JWT from header ${this.sources.headerName} or cookie matching regex ${this.sources.cookieRegex?.source}.`)
        return undefined
    }
}

const extractJwtFromHeaders = (headers: APIGatewayRequestAuthorizerEventHeaders, jwtHeaderName: string): string | undefined =>
    headers[jwtHeaderName]?.replace("Bearer ", "")

const findFirstCookieMatching = (cookies: string[], cookieRegex: RegExp): RequestCookie | undefined =>
    cookies
        .map((value) => {
            const split = value.split("=")
            return {
                name: split[0],
                value: split[1]
            }
        })
        .find((cookie) => cookieRegex.test(cookie.name))
