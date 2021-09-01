import mail from "./mailService";
import resetHTML from "@static/email-templates/reset/index.html";
import { forgotPasswordLink } from "@utils/constants";

interface Props {
  token: string;
  to: string;
}

const forgotPasswordSubject = "Reset your password";

async function sendResetPasswordEmail({ token, to }: Props) {
  const readyHTML = resetHTML.replace(/{{link}}/g, forgotPasswordLink + token);
  return mail.sendMail(to, forgotPasswordSubject, readyHTML);
}

export default sendResetPasswordEmail;
