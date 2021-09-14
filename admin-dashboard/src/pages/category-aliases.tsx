import React from "react";
import Layout from "../layouts";
import Content from "../layouts/content";
import SEO from "../components/seo";
import CategoryAliasesTable from "../containers/category-aliases/table";

const CategoriesPage: React.FC = () => {
  return (
    <Layout>
      <SEO />
      <Content fullHeight align="top">
        <h2>Category Aliases</h2>
        <CategoryAliasesTable />
      </Content>
    </Layout>
  );
};

export default CategoriesPage;
