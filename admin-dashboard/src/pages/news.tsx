import React from "react";
import Layout from "../layouts";
import Content from "../layouts/content";
import SEO from "../components/seo";
import NewsTable from "../containers/news/table";

const NewsPage: React.FC = () => {
  return (
    <Layout>
      <SEO />
      <Content fullHeight align="top">
        <h2>News</h2>
        <NewsTable />
      </Content>
    </Layout>
  );
};

export default NewsPage;
