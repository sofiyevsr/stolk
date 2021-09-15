import React from "react";
import Layout from "../layouts";
import Content from "../layouts/content";
import SEO from "../components/seo";
import CommentsTable from "../containers/comments/table";

const Comments: React.FC = () => {
  return (
    <Layout>
      <SEO />
      <Content fullHeight align="top">
        <h2>Comments</h2>
        <CommentsTable />
      </Content>
    </Layout>
  );
};

export default Comments;
