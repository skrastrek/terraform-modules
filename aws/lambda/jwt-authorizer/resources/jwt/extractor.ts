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
            const jwtFromHeader = extractJwtFromHeaders(this.sources.headerName, event.headers)

            if (jwtFromHeader !== undefined) {
                console.debug(`Found JWT from header: ${this.sources.headerName}.`)
                return jwtFromHeader
            }
        }

        if (this.sources.cookieRegex !== undefined) {
            const jwtFromCookie = this.extractJwtFromCookies(event)

            if (jwtFromCookie !== undefined) {
                console.debug(`Found JWT from cookie: ${jwtFromCookie.name}.`)
                return jwtFromCookie.value
            }
        }

        console.log(`Could not find any JWT from header ${this.sources.headerName} or cookie matching regex ${this.sources.cookieRegex.source}.`)
        return undefined
    }

    private extractJwtFromCookies = (event: APIGatewayRequestAuthorizerEvent): RequestCookie | undefined =>
        findFirstCookieMatching(event.headers["cookie"]?.split("; ") ?? [], this.sources.cookieRegex)
}

export class AuthorizerEventV2JwtExtractor implements JwtExtractor<APIGatewayRequestAuthorizerEventV2> {

    constructor(public sources: JwtSources) {
    }

    extract(event: APIGatewayRequestAuthorizerEventV2): string | undefined {
        if (this.sources.headerName !== undefined) {
            const jwtFromHeader = extractJwtFromHeaders(this.sources.headerName.toLowerCase(), event.headers)

            if (jwtFromHeader !== undefined) {
                console.debug(`Found JWT from header: ${this.sources.headerName}.`)
                return jwtFromHeader
            }
        }

        if (this.sources.cookieRegex !== undefined) {
            const jwtFromCookie = this.extractJwtFromCookies(event)

            if (jwtFromCookie !== undefined) {
                console.debug(`Found JWT from cookie: ${jwtFromCookie.name}.`)
                return jwtFromCookie.value
            }
        }

        console.log(`Could not find any JWT from header ${this.sources.headerName} or cookie matching regex ${this.sources.cookieRegex.source}.`)
        return undefined
    }

    private extractJwtFromCookies = (event: APIGatewayRequestAuthorizerEventV2): RequestCookie | undefined =>
        findFirstCookieMatching(event.cookies ?? [], this.sources.cookieRegex)
}

const extractJwtFromHeaders = (jwtHeaderName: string, headers: APIGatewayRequestAuthorizerEventHeaders): string | undefined =>
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
