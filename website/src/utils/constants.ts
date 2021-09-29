const isProduction = process.env.NEXT_PUBLIC_VERCEL_ENV === "production";
export const API_URL = isProduction
  ? process.env.NEXT_PUBLIC_API_URL
  : "http://localhost:4500";

export const passwordRegex =
  /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d@$!%*?&_^-]{7,}$/;
