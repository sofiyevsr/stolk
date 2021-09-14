import React from "react";
import Layout from "../layouts";
import Content from "../layouts/content";
import SEO from "../components/seo";
import CategoriesTable from "../containers/categories/table";

const CategoriesPage: React.FC = () => {
  return (
    <Layout>
      <SEO />
      <Content fullHeight align="top">
        <h2>Categories</h2>
        <CategoriesTable />
      </Content>
    </Layout>
  );
};

export default CategoriesPage;
