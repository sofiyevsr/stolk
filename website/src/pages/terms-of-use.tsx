import { useTranslation } from "next-i18next";
import { serverSideTranslations } from "next-i18next/serverSideTranslations";
import React from "react";
import TermsOfUseContent from "../content/TermsOfUseContent";
import { Meta } from "../layout/Meta";
import Navbar from "../navigation/Navbar";
import { Banner } from "../templates/Banner";
import { Footer } from "../templates/Footer";

const TermsOfUse = () => {
  const { t } = useTranslation();
  return (
    <div className="antialiased text-gray-600">
      <Meta
        title={t("terms-of-use.seo.title")}
        description={t("terms-of-use.seo.description")}
      />
      <Navbar />
      <TermsOfUseContent />
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

export default TermsOfUse;
