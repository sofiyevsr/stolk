import { useTranslation } from "next-i18next";
import { serverSideTranslations } from "next-i18next/serverSideTranslations";
import React from "react";
import PrivacyPolicyContent from "../content/PrivacyPolicyContent";
import { Meta } from "../layout/Meta";
import Navbar from "../navigation/Navbar";
import { Banner } from "../templates/Banner";
import { Footer } from "../templates/Footer";

const PrivacyPolicy = () => {
  const { t } = useTranslation();
  return (
    <div className="antialiased text-gray-600">
      <Meta
        title={t("privacy-policy.seo.title")}
        description={t("privacy-policy.seo.description")}
      />
      <Navbar />
      <PrivacyPolicyContent />
      <Banner />
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

export default PrivacyPolicy;
