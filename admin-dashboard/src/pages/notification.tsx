import React from "react";
import Layout from "../layouts";
import Content from "../layouts/content";
import SEO from "../components/seo";
import SendNotificationForm from "../containers/notification/sendNotificationForm";

const Notification: React.FC = () => {
  return (
    <Layout>
      <SEO />
      <Content fullHeight align="top">
        <SendNotificationForm />
      </Content>
    </Layout>
  );
};

export default Notification;
