import {JwtRsaVerifier} from "aws-jwt-verify/jwt-rsa";
import {JwtPayload} from "aws-jwt-verify/jwt-model";
import {
    APIGatewayAuthorizerWithContextResult,
    APIGatewayRequestAuthorizerEvent,
    APIGatewayRequestAuthorizerEventV2
} from "aws-lambda";
import {APIGatewaySimpleAuthorizerWithContextResult} from "aws-lambda/trigger/api-gateway-authorizer";
import {AuthContextV1, AuthContextV2, Primitive, PrimitiveValues, UserAttributes} from "../types";
import {JwtSources} from "./sources";
import {JwtEnricher} from "./enricher";
import {AuthorizerEventV1JwtExtractor, AuthorizerEventV2JwtExtractor, JwtExtractor} from "./extractor";

export abstract class JwtAuthorizer<E, R, Attributes> {

    abstract readonly extractor: JwtExtractor<E>
    abstract readonly verifier: JwtRsaVerifier<any, any, any>
    abstract readonly enricher: JwtEnricher<Attributes>

    abstract result: (event: E, verifiedJwt: (JwtPayload), attributes?: Attributes) => R;

    authorize = async (event: E): Promise<R> => {
        const jwt = this.extractor.extract(event)

        if (jwt === undefined) {
            throw new Error("Unauthorized")
        }

        let verifiedJwt: JwtPayload
        try {
            // If the token is not valid, an error is thrown:
            verifiedJwt = await this.verifier.verify(jwt)
        } catch (error) {
            console.error("Invalid JWT:", error.message)
            throw new Error("Unauthorized")
        }

        return this.result(event, verifiedJwt, await this.enricher.enrich(verifiedJwt))
    };
}

export class ApiGatewayV1JwtAuthorizer extends JwtAuthorizer<APIGatewayRequestAuthorizerEvent, APIGatewayAuthorizerWithContextResult<AuthContextV1>, UserAttributes> {
    constructor(
        private jwtSources: JwtSources,
        private jwtVerifier: JwtRsaVerifier<any, any, any>,
        private jwtEnricher: JwtEnricher<UserAttributes>,
    ) {
        super();
    }

    extractor = new AuthorizerEventV1JwtExtractor(this.jwtSources)
    verifier = this.jwtVerifier
    enricher = this.jwtEnricher

    result = (event: APIGatewayRequestAuthorizerEvent, verifiedJwt: JwtPayload, attributes?: UserAttributes): APIGatewayAuthorizerWithContextResult<AuthContextV1> => ({
        principalId: verifiedJwt.sub,
        policyDocument: {
            Version: "2012-10-17",
            Statement: [
                {
                    Action: "execute-api:Invoke",
                    Effect: "Allow",
                    Resource: event.methodArn
                }
            ]
        },
        context: {
            ...primitiveValues(verifiedJwt),
            ...attributes,
        },
        usageIdentifierKey: verifiedJwt.sub
    });
}

export class ApiGatewayV2JwtAuthorizer extends JwtAuthorizer<APIGatewayRequestAuthorizerEventV2, APIGatewaySimpleAuthorizerWithContextResult<AuthContextV2>, UserAttributes> {
    constructor(
        private jwtSources: JwtSources,
        private jwtVerifier: JwtRsaVerifier<any, any, any>,
        private jwtEnricher: JwtEnricher<UserAttributes>,
    ) {
        super();
    }

    extractor = new AuthorizerEventV2JwtExtractor(this.jwtSources)
    verifier = this.jwtVerifier
    enricher = this.jwtEnricher

    result = (event: APIGatewayRequestAuthorizerEventV2, verifiedJwt: JwtPayload, attributes?: UserAttributes): APIGatewaySimpleAuthorizerWithContextResult<AuthContextV2> => ({
        isAuthorized: true,
        context: {
            ...verifiedJwt,
            ...attributes
        }
    });
}

function primitiveValues(object: any): PrimitiveValues {
    return Object.entries(object)
        .filter<[string, Primitive]>((entry): entry is [string, Primitive] => isPrimitive(entry[1]))
        .reduce((result, curr) => ({...result, [curr[0]]: curr[1]}), {})
}

function isPrimitive(value?: any): value is Primitive {
    switch (typeof value) {
        case "boolean":
        case "string":
        case "number":
            return true

        default:
            return false
    }
}
