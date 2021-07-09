import nodeMail, { TransportOptions } from "nodemailer";

const transport = {
  host: process.env.EMAIL_HOST as string,
  port: process.env.EMAIL_PORT as string,
  secure: true,
  auth: {
    user: process.env.EMAIL_USER as string,
    pass: process.env.EMAIL_PASSWORD as string,
  },
} as TransportOptions;

const service = nodeMail.createTransport(transport);

const sendMail = async (to: string, subject: string, html: string) => {
  return service.sendMail({
    from: '"Support" <support@pzzle.icu>',
    to,
    subject,
    html,
  });
};

export default { sendMail };
