import mail from "./mailService";
import confirmHTML from "@static/email-templates/verification/index.html";
import { emailConfirmationLink } from "@utils/constants";

interface Props {
  token: string;
  to: string;
  firstName: string;
  id: number;
}

const emailVerificationSubject = "Verify your email";

async function sendAccountConfirmationEmail({
  token,
  to,
  id,
  firstName,
}: Props) {
  const readyHTML = confirmHTML
    .replace(/{{link}}/g, emailConfirmationLink + "?t=" + token + "&i=" + id)

    .replace("{{user_first_name}}", firstName);
  return mail.sendMail(to, emailVerificationSubject, readyHTML);
}

export default sendAccountConfirmationEmail;
