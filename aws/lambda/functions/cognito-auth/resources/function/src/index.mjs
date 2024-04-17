const {Authenticator} = require('cognito-at-edge');

const authenticator = new Authenticator({
    region: `eu-north-1`,
    userPoolId: `arn:aws:cognito-idp:eu-north-1:992382508076:userpool/eu-north-1_7GIz0Fd0w`,
    userPoolAppId: `2gtt9349698f9fol04d7u2lmip`,
    userPoolDomain: `auth.skrastrek.io`,
});

exports.handler = async (request) => authenticator.handle(request);
