import React from "react";
import Layout from "../layouts";
import Content from "../layouts/content";
import SEO from "../components/seo";

const Notification: React.FC = () => {
  return (
    <Layout>
      <SEO />
      <Content fullHeight></Content>
    </Layout>
  );
};

export default Notification;
