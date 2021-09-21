import mail from "./mailService";
import resetHTML from "@static/email-templates/reset/index.html";
import { forgotPasswordLink } from "@utils/constants";

interface Props {
  token: string;
  to: string;
  id: number;
}

const forgotPasswordSubject = "Reset your password";

async function sendResetPasswordEmail({ token, id, to }: Props) {
  const readyHTML = resetHTML.replace(
    /{{link}}/g,
    forgotPasswordLink + "?t=" + token + "&i=" + id
  );
  return mail.sendMail(to, forgotPasswordSubject, readyHTML);
}

export default sendResetPasswordEmail;
