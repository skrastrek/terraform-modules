import {Handler} from "aws-lambda/handler";

export type S3ObjectEventHandler = Handler<S3ObjectEvent, void>;

export interface S3ObjectEvent {
  configuration: {
    accessPointArn: string;
    supportingAccessPointArn: string;
    payload: string;
  }
  getObjectContext: {
    inputS3Url: string;
    outputRoute: string;
    outputToken: string;
  };
  protocolVersion: string
  userRequest: {
    url: string;
    headers: {
      [name: string]: string | undefined;
    }
  }
  userIdentity: {
    type: string;
    principalId: string;
    arn: string;
    accountId: string;
    accessKeyId: string,
  }
  xAmzRequestId: string;
}
