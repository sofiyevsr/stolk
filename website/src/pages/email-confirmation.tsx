import { GetServerSidePropsContext } from "next";
import { useTranslation } from "next-i18next";
import { serverSideTranslations } from "next-i18next/serverSideTranslations";
import React from "react";
import ConfirmLayout from "../content/ConfirmLayout";
import { Meta } from "../layout/Meta";
import Navbar from "../navigation/Navbar";
import { Footer } from "../templates/Footer";
import { API_URL } from "../utils/constants";

const EmailConfirmation = ({ checkOkay }: any) => {
  const { t } = useTranslation();
  return (
    <div className="min-h-screen antialiased text-gray-600">
      <Meta
        title={t("email-confirmation.seo.title")}
        description={t("email-confirmation.seo.description")}
      />
      <Navbar />
      <ConfirmLayout checkOkay={checkOkay} />
      <Footer />
    </div>
  );
};

export async function getServerSideProps({
  locale,
  query,
}: GetServerSidePropsContext & { locale: string }) {
  const { t, i } = query;
  const localeProps = await serverSideTranslations(locale);

  if (typeof t !== "string" || typeof i !== "string")
    return {
      props: {
        checkOkay: false,
        ...localeProps,
      },
    };

  try {
  } catch (error) {}
  const data = await fetch(`${API_URL}/auth/verify-email`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ token: t, id: i }),
  }).catch((_) => {});
  if (data?.ok === true)
    return {
      props: {
        checkOkay: true,
        ...localeProps,
      },
    };
  return {
    props: {
      checkOkay: false,
      ...localeProps,
    },
  };
}

export default EmailConfirmation;
