import {
    AdminCreateUserCommand,
    AdminLinkProviderForUserCommand,
    AdminSetUserPasswordCommand,
    AttributeType,
    CognitoIdentityProviderClient,
    ListUsersCommand,
} from "@aws-sdk/client-cognito-identity-provider";
import {PreSignUpTriggerHandler} from "aws-lambda";
import {StringMap} from "aws-lambda/trigger/cognito-user-pool-trigger/_common";

const cognito = new CognitoIdentityProviderClient()

export const handler: PreSignUpTriggerHandler = async event => {

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

    // --> User has registered with Google/Facebook external providers
    if (triggerSource === "PreSignUp_ExternalProvider") {
        const existingUser = await findUserByEmail(userPoolId, email);
        console.log("existingUser:", existingUser);
        // userName example: "Facebook_12324325436" or "Google_1237823478"
        const [providerNameValue, providerUserId] = userName.split("_");

        // Uppercase the first letter because the event sometimes
        // has it as google_1234 or facebook_1234. In the call to `adminLinkProviderForUser`
        // the provider name has to be Google or Facebook (first letter capitalized)
        const providerName =
            providerNameValue.charAt(0).toUpperCase() + providerNameValue.slice(1);

        if (existingUser) {
            // user already has cognito account
            const sourceUserId = providerUserId;
            const destinationUserId = existingUser.Username;
            await linkAccounts(
                sourceUserId,
                destinationUserId,
                providerName,
                userPoolId
            );
        } else {
            //1. create a native cognito account
            const userAttributes = createUserAttributes(providerName, event.request.userAttributes)
            console.log(JSON.stringify(userAttributes))
            const createdCognitoUser = await adminCreateUser(userPoolId, email, userAttributes);

            //2. change the password, to change status from FORCE_CHANGE_PASSWORD to CONFIRMED
            await adminSetUserPassword(userPoolId, email);

            //3. merge the social and the native accounts
            const cognitoNativeUsername =
                createdCognitoUser.User?.Username || "username-not-found";
            await linkAccounts(
                providerUserId,
                cognitoNativeUsername,
                providerName,
                userPoolId
            );
        }
        event.response.autoConfirmUser = true;
        event.response.autoVerifyEmail = true;
    }
    console.log("Result:", JSON.stringify(event))
    return event
}

const createUserAttributes = (providerName: string, attributes: StringMap): AttributeType[] => {

    // Facebook does not include email_verified claim, but the email can be trusted.
    if (providerName === "Facebook") {
        attributes.email_verified = "true"
    }

    return Object.entries(attributes)
        .map((entry) => ({
            Name: entry[0],
            Value: entry[1]
        }))
        .filter(attribute => !attribute.Name.startsWith("cognito:"));
}

const findUserByEmail = async (userPoolId: string, email: string) => {
    try {
        const response = await cognito.send(
            new ListUsersCommand({
                UserPoolId: userPoolId,
                Filter: `email = "${email}"`,
            })
        )

        if (response.Users && response.Users.length > 0) {
            return response.Users[0];
        } else {
            return null;
        }
    } catch (err) {
        console.error("Error finding user by email:", err);
        throw err;
    }
};

const linkAccounts = async (
    sourceUserId: string,
    destinationUserId: string,
    providerName: string,
    userPoolId: string,
) => {
    try {
        await cognito
            .send(new AdminLinkProviderForUserCommand({
                UserPoolId: userPoolId,
                SourceUser: {
                    ProviderName: providerName, //Google
                    ProviderAttributeName: "Cognito_Subject",
                    ProviderAttributeValue: sourceUserId,
                },
                DestinationUser: {
                    ProviderName: "Cognito",
                    ProviderAttributeValue: destinationUserId,
                },
            }))
    } catch (err) {
        console.error("Error linking user accounts:", err);
        throw err;
    }
};

const adminCreateUser = async (userPoolId: string, username: string, userAttributes: AttributeType[]) => {
    return cognito.send(new AdminCreateUserCommand({
        UserPoolId: userPoolId,
        // SUPPRESS prevents sending an email with the temporary password
        // to the user on account creation
        MessageAction: "SUPPRESS",
        Username: username,
        UserAttributes: userAttributes,
    }))
};

const adminSetUserPassword = async (userPoolId: string, email: string) => {
    return cognito.send(new AdminSetUserPasswordCommand({
        Password: generatePassword(),
        UserPoolId: userPoolId,
        Username: email,
        Permanent: true,
    }))
};

const generatePassword = () => {
    return `${Math.random() // Generate random number, eg: 0.123456
        .toString(36) // Convert  to base-36 : "0.4fzyo82mvyr"
        .slice(-16)}42T`; // Cut off last 16 characters; and add a number and uppercase character to match cognito password policy
};
