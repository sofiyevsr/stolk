import useTableLoader from "../../utils/hooks/table-data-loader";
import { DataGrid } from "@mui/x-data-grid";
import NewsApi from "../../utils/api/news";
import { useMemo, useState } from "react";
import { Button, Modal } from "../../widgets";

function NewsTable() {
  const newsApi = new NewsApi();
  const getAll = async ({ lastID }: { lastID: number | null }) => {
    const {
      body: { news, has_reached_end },
    }: any = await newsApi.getAll({ lastID });
    return { items: news, hasReachedEnd: has_reached_end };
  };
  const { data, headers, isLoading, onPageChange } = useTableLoader({
    fetchData: getAll as any,
  });
  const [showModal, setShowModal] = useState(false);
  const [selectedIndex, setSelectedIndex] = useState<number>();

  const rowCount = useMemo(() => {
    if (!data) {
      return 0;
    }
    if (data.hasReachedEnd === true) return data.items.length;
    return data.items.length + 10;
  }, [data]);

  return (
    <div style={{ position: "relative" }}>
      <DataGrid
        onPageChange={onPageChange}
        onSelectionModelChange={([index]) => {
          setSelectedIndex(index as number);
        }}
        hideFooterSelectedRowCount
        loading={isLoading}
        autoHeight={true}
        rows={(data?.items as any[]) ?? []}
        rowCount={rowCount}
        pageSize={10}
        rowsPerPageOptions={[10]}
        columns={headers}
      />
      <div style={{ position: "absolute", bottom: 10, left: 10 }}>
        {selectedIndex && (
          <Button
            color="danger"
            onClick={() => {
              setShowModal(true);
            }}
          >
            Hide News
          </Button>
        )}
      </div>
      <Modal
        show={showModal}
        onClose={() => {
          setShowModal(false);
        }}
        onAction={() => {
          // send request
        }}
      >
        <p>News will be hidden</p>
      </Modal>
    </div>
  );
}

export default NewsTable;
