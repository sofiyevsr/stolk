import gcadminSdk from "@utils/gcadmin-sdk";

async function validateNotificationToken(token: string) {
  await gcadminSdk.messaging.send({ token }, true);
}

export default validateNotificationToken;
