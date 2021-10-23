import admin from "firebase-admin";

const app = admin.initializeApp();
const messaging = app.messaging();

export default { app, messaging };
