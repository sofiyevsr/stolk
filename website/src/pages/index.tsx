import { serverSideTranslations } from "next-i18next/serverSideTranslations";
import React from "react";
import { Meta } from "../layout/Meta";
import { Banner } from "../templates/Banner";
import Navbar from "../navigation/Navbar";
import { Footer } from "../templates/Footer";
import { Hero } from "../templates/Hero";
import VerticalFeatures from "../templates/VerticalFeatures";
import PhoneShowcase from "../carousel/PhoneShowcase";
import { useTranslation } from "next-i18next";

const Index = () => {
  const { t } = useTranslation();
  return (
    <div className="antialiased text-gray-600">
      <Meta title={t("home.seo.title")} description={t("home.seo.description")} />
      <Navbar />
      <Hero />
      <VerticalFeatures />
      <PhoneShowcase />
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

export default Index;
