const isProduction = process.env.VERCEL_ENV === "production";
export const API_URL = isProduction
  ? process.env.API_URL
  : "http://localhost:4500/admin";
