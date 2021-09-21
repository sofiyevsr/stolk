import React from "react";
import Layout from "../layouts";
import Content from "../layouts/content";
import SEO from "../components/seo";
import CommentReportsTable from "../containers/comment-reports/table";

const CommentReports: React.FC = () => {
  return (
    <Layout>
      <SEO />
      <Content fullHeight align="top">
          <h2>Comment Reports</h2>
        <CommentReportsTable />
      </Content>
    </Layout>
  );
};

export default CommentReports;
