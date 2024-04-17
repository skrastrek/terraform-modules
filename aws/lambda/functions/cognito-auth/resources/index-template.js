const {Authenticator} = require('cognito-at-edge');

const authenticator = new Authenticator({
    region: `${cognito_user_pool_region_id}`,
    userPoolId: `${cognito_user_pool_id}`,
    userPoolAppId: `${cognito_user_pool_client_id}`,
    userPoolDomain: `${cognito_user_pool_domain}`,
});

exports.handler = async (request) => authenticator.handle(request);
