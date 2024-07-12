export interface JwtSources {
    headerName: string | undefined
    cookieRegex: RegExp | undefined
}

export const getJwtSourcesFromEnv = (): JwtSources => ({
    headerName: process.env.JWT_SOURCE_HEADER_NAME,
    cookieRegex: process.env.JWT_SOURCE_COOKIE_REGEX ? RegExp(process.env.JWT_SOURCE_COOKIE_REGEX) : undefined
})
