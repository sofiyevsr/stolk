import React from "react";
import Layout from "../layouts";
import Content from "../layouts/content";
import SEO from "../components/seo";
import { Table } from "../widgets";
import DataTable from "../widgets/ui/table/dataTable";
import SourcesApi from "../utils/api/sources";

const headers = [];

const Sources: React.FC = () => {
  return (
    <Layout>
      <SEO />
      <Content fullHeight align={"top"}>
        <Table>
          <DataTable apiClient={new SourcesApi()} headerNames={[]} />
        </Table>
      </Content>
    </Layout>
  );
};

export default Sources;
