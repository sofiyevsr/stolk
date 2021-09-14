import React from "react";
import Layout from "../layouts";
import Content from "../layouts/content";
import SEO from "../components/seo";
import NewsReportsTable from "../containers/news-reports/table";

const NewsReports: React.FC = () => {
  return (
    <Layout>
      <SEO />
      <Content fullHeight align="top">
          <h2>News Reports</h2>
        <NewsReportsTable />
      </Content>
    </Layout>
  );
};

export default NewsReports;
