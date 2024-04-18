import {Authenticator} from "cognito-at-edge";

const authenticator = new Authenticator({
    region: `${cognito_user_pool_region_id}`,
    userPoolId: `${cognito_user_pool_id}`,
    userPoolDomain: `${cognito_user_pool_domain}`,
    userPoolAppId: `${cognito_user_pool_client_id}`,
    userPoolAppSecret: `${cognito_user_pool_client_secret}`,
    parseAuthPath: `${callback_path}`,
    cookieDomain: `${cookie_domain}`,
    cookiePath: `${cookie_path}`,
    sameSite: `${cookie_same_site}`,
    httpOnly: `${cookie_http_only}`,
    logoutConfiguration: {
        logoutUri: `${logout_path}`,
        logoutRedirectUri: `${logout_redirect_path}`
    }
});

export const handler = async (event, context) => authenticator.handle(event);
