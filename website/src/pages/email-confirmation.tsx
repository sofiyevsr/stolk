import { useTranslation } from "next-i18next";
import { serverSideTranslations } from "next-i18next/serverSideTranslations";
import { useRouter } from "next/router";
import React, { useEffect, useState } from "react";
import ConfirmLayout from "../content/ConfirmLayout";
import { Meta } from "../layout/Meta";
import Navbar from "../navigation/Navbar";
import Spinner from "../spinner/Spinner";
import { Footer } from "../templates/Footer";
import { API_URL } from "../utils/constants";

const EmailConfirmation = ({}: any) => {
  const { t } = useTranslation();
  const {
    query: { t: token, i: id },
  } = useRouter();
  const [checkOkay, setCheckOkay] = useState(false);
  const [isLoading, setLoading] = useState(true);

  useEffect(() => {
    if (typeof token !== "string" || typeof id !== "string") {
      setLoading(false);
      return;
    }

    fetch(`${API_URL}/auth/verify-email`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ token, id }),
    })
      .then((data) => {
        if (data?.ok === true) {
          setCheckOkay(true);
        }
      })
      .catch((_) => {})
      .finally(() => {
        setLoading(false);
      });
  }, []);

  return (
    <div className="min-h-screen antialiased text-gray-600">
      <Meta
        title={t("email-confirmation.seo.title")}
        description={t("email-confirmation.seo.description")}
      />
      <Navbar />
      {isLoading ? <Spinner /> : <ConfirmLayout checkOkay={checkOkay} />}
      <Footer />
    </div>
  );
};

export async function getStaticProps({ locale }: { locale: string }) {
  return {
    props: {
      ...(await serverSideTranslations(locale)),
    },
  };
}

export default EmailConfirmation;
