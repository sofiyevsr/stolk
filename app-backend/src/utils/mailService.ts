import {
  SendEmailCommand,
  SendEmailCommandInput,
  SESClient,
} from "@aws-sdk/client-ses";

const isProd =
  process.env.NODE_ENV === "production" || process.env.NODE_ENV === "staging";
const ses = new SESClient({
  region: "eu-west-3",
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY as string,
    secretAccessKey: process.env.AWS_SECRET_KEY as string,
  },
});

const sendMail = async (to: string, subject: string, html: string) => {
  const input: SendEmailCommandInput = {
    Source: "no-reply@stolk.app",
    Message: {
      Subject: {
        Data: subject,
      },
      Body: { Html: { Data: html } },
    },
    Destination: {
      ToAddresses: isProd ? [to] : [],
    },
  };

  const emailCommand = new SendEmailCommand(input);
  return ses.send(emailCommand);
};

export default { sendMail };
