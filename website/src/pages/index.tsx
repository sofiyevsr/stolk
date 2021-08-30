import { serverSideTranslations } from "next-i18next/serverSideTranslations";
import React from "react";
import { Meta } from "../layout/Meta";
import { Banner } from "../templates/Banner";
import Navbar from "../navigation/Navbar";
import { Footer } from "../templates/Footer";
import { Hero } from "../templates/Hero";
import { VerticalFeatures } from "../templates/VerticalFeatures";
import { AppConfig } from "../utils/AppConfig";

const Index = () => (
  <div className="antialiased text-gray-600">
    <Meta title={AppConfig.title} description={AppConfig.description} />
    <Navbar />
    <Hero />
    <VerticalFeatures />
    <Banner />
    <Footer />
  </div>
);

export async function getStaticProps({ locale }: { locale: string }) {
  return {
    props: {
      ...(await serverSideTranslations(locale)),
    },
  };
}

export default Index;
