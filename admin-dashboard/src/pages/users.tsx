import React from "react";
import Layout from "../layouts";
import Content from "../layouts/content";
import SEO from "../components/seo";
import UsersTable from "../containers/users/table";

const Users: React.FC = () => {
  return (
    <Layout>
      <SEO />
      <Content fullHeight align="top">
        <h2>Users</h2>
        <UsersTable />
      </Content>
    </Layout>
  );
};

export default Users;
