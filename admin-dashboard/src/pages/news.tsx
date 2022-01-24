import React, { useState } from "react";
import Layout from "../layouts";
import Content from "../layouts/content";
import SEO from "../components/seo";
import NewsTable from "../containers/news/table";
import { Button } from "../widgets";
import CleanupModal from "../containers/news/cleanupModal";

const NewsPage: React.FC = () => {
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
          <h2>News</h2>
          <Button
            onClick={() => {
              setModalActive(true);
            }}
          >
            Cleanup
          </Button>
        </div>
        <NewsTable />
        <CleanupModal
          show={modalActive}
          onClose={() => {
            setModalActive(false);
          }}
        />
      </Content>
    </Layout>
  );
};

export default NewsPage;
