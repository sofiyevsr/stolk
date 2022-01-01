import React, { useState } from "react";
import Layout from "../layouts";
import Content from "../layouts/content";
import SEO from "../components/seo";
import SourcesTable from "../containers/sources/table";
import { Button } from "../widgets";

const Sources: React.FC = () => {
  const [modalActive, setModalActive] = useState(false);
  return (
    <Layout>
      <SEO />
      <Content fullHeight align="top">
        <div
          style={{
            display: "flex",
            padding: "10px 0",
            justifyContent: "space-between",
          }}
        >
          <h2>Sources</h2>
          <Button
            onClick={() => {
              setModalActive(true);
            }}
          >
            Add
          </Button>
        </div>
        <SourcesTable show={modalActive} setModalActive={setModalActive} />
      </Content>
    </Layout>
  );
};

export default Sources;
