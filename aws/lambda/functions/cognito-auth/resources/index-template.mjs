import {Authenticator} from "cognito-at-edge";

const authenticator = new Authenticator({
    region: `${cognito_user_pool_region_id}`,
    userPoolId: `${cognito_user_pool_id}`,
    userPoolAppId: `${cognito_user_pool_client_id}`,
    userPoolDomain: `${cognito_user_pool_domain}`,
    parseAuthPath: `${callback_path}`,
    logoutConfiguration: {
        logoutUri: `${logout_path}`,
        logoutRedirectUri: `${logout_redirect_path}`
    }
});

export const handler = async (event, context) => authenticator.handle(event);
