import mail from "./mailService";
import confirmHTML from "@static/email-templates/verification/index.html";
import { emailConfirmationLink } from "@utils/constants";

interface Props {
  token: string;
  to: string;
  firstName: string;
}

const emailVerificationSubject = "Verify your email";

async function sendAccountConfirmationEmail({ token, to, firstName }: Props) {
  const readyHTML = confirmHTML
    .replace(/{{link}}/g, emailConfirmationLink + token)
    .replace("{{user_first_name}}", firstName);
  return mail.sendMail(to, emailVerificationSubject, readyHTML);
}

export default sendAccountConfirmationEmail;
