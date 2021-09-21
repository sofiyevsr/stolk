import React from "react";
import Layout from "../layouts";
import Content from "../layouts/content";
import SEO from "../components/seo";
import SourcesTable from "../containers/sources/table";

const Sources: React.FC = () => {
  return (
    <Layout>
      <SEO />
      <Content fullHeight align={"top"}>
        <h2>Sources</h2>
        <SourcesTable />
      </Content>
    </Layout>
  );
};

export default Sources;
