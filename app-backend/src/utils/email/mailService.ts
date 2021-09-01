import {
  SendEmailCommand,
  SendEmailCommandInput,
  SESClient,
} from "@aws-sdk/client-ses";
import { emailAssetS3Link } from "@utils/constants";

const isProd = process.env.NODE_ENV === "production";

const ses = new SESClient({
  region: "eu-west-3",
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY as string,
    secretAccessKey: process.env.AWS_SECRET_KEY as string,
  },
});

const sendMail = async (to: string, subject: string, html: string) => {
  if (!isProd) {
    return;
  }
  const readyHTML = html.replace(/{{asset_link}}/g, emailAssetS3Link);
  const input: SendEmailCommandInput = {
    Source: "Stolk <no-reply@stolk.app>",
    Message: {
      Subject: {
        Data: subject,
      },
      Body: { Html: { Data: readyHTML } },
    },
    Destination: {
      ToAddresses: [to],
    },
  };

  const emailCommand = new SendEmailCommand(input);
  return ses.send(emailCommand);
};

export default { sendMail };
