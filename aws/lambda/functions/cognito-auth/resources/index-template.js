const {Authenticator} = require('cognito-at-edge');

const authenticator = new Authenticator({
    // Replace these parameter values with those of your own environment
    region: `${cognito_user_pool_region_id}`, // user pool region
    userPoolId: `${cognito_user_pool_id}`, // user pool ID
    userPoolAppId: `${cognito_user_pool_client_id}`, // user pool app client ID
    userPoolDomain: `${cognito_user_pool_domain}`, // user pool domain
});

exports.handler = async (request) => authenticator.handle(request);
