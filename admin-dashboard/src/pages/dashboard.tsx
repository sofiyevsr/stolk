import React from "react";
import Layout from "../layouts";
import Content from "../layouts/content";
import WelcomeArea from "../containers/dashboard/welcome-area";
import LeftRowThree from "../containers/dashboard/left-row-three";
import SEO from "../components/seo";

const Dashboard: React.FC = () => {
  return (
    <Layout>
      <SEO />
      <Content fullHeight align="top">
        <WelcomeArea />
        <LeftRowThree />
      </Content>
    </Layout>
  );
};

export default Dashboard;
