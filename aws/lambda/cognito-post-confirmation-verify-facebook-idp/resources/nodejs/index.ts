import {
    AdminUpdateUserAttributesCommand,
    CognitoIdentityProviderClient,
} from "@aws-sdk/client-cognito-identity-provider";
import {PostConfirmationTriggerHandler} from "aws-lambda";

const cognito = new CognitoIdentityProviderClient()

const CLAIM_EMAIL_VERIFIED = "email_verified"

export const handler: PostConfirmationTriggerHandler = async event => {

    console.log("Event:", JSON.stringify(event))

    const {
        triggerSource,
        userPoolId,
        userName,
        request: {
            // only properties specified as required are available here
            userAttributes: {email},
        },
    } = event;

    return event
}

const verifyEmail = async (userPoolId: string, username: string) => {
    return cognito.send(new AdminUpdateUserAttributesCommand({
        UserPoolId: userPoolId,
        Username: username,
        UserAttributes: [
            {
                Name: CLAIM_EMAIL_VERIFIED,
                Value: "true"
            }
        ]
    }))
}
