const isProduction = process.env.REACT_APP_VERCEL_ENV === "production";
export const API_URL = isProduction
  ? process.env.REACT_APP_API_URL
  : "http://localhost:4500/admin";
