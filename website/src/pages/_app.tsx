import { appWithTranslation } from "next-i18next";
import { AppProps } from "next/app";

import "../styles/main.css";

const MyApp = ({ Component, pageProps }: AppProps) => (
  <Component {...pageProps} />
);

export default appWithTranslation(MyApp);
