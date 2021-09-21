import { appWithTranslation } from "next-i18next";
import { AppProps } from "next/app";
import { useRouter } from "next/router";
import NProgress from "nprogress";
import React, { useEffect } from "react";
import { ToastContainer } from "react-toastify";

import "../styles/main.css";
import "../styles/nprogress.css";
import "react-toastify/dist/ReactToastify.css";

const MyApp = ({ Component, pageProps }: AppProps) => {
  const router = useRouter();

  useEffect(() => {
    const handleStart = () => {
      NProgress.start();
    };
    const handleStop = () => {
      NProgress.done();
    };

    router.events.on("routeChangeStart", handleStart);
    router.events.on("routeChangeComplete", handleStop);
    router.events.on("routeChangeError", handleStop);

    return () => {
      router.events.off("routeChangeStart", handleStart);
      router.events.off("routeChangeComplete", handleStop);
      router.events.off("routeChangeError", handleStop);
    };
  }, [router]);
  return (
    <>
      <Component {...pageProps} />
      <ToastContainer position="bottom-center" closeOnClick />
    </>
  );
};

export default appWithTranslation(MyApp);
