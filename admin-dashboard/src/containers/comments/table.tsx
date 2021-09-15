import useTableLoader from "../../utils/hooks/table-data-loader";
import { DataGrid } from "@mui/x-data-grid";
import { useState } from "react";
import { Button, Modal } from "../../widgets";
import CommentsApi from "../../utils/api/comments";
import { toast } from "react-toastify";

const commentsApi = new CommentsApi();
function CommentsTable() {
  const getAll = async ({ lastID }: { lastID: number | null }) => {
    const {
      body: { comments, has_reached_end },
    }: any = await commentsApi.getAll({ lastID });
    return { items: comments, hasReachedEnd: has_reached_end };
  };
  const { data, rowCount, headers, isLoading, onPageChange, modifyData } =
    useTableLoader({
      fetchData: getAll as any,
    });
  const [selectedID, setSelectedID] = useState<number>();
  const [deleteModalActive, setDeleteModalActive] = useState(false);

  return (
    <div style={{ position: "relative" }}>
      <DataGrid
        onSelectionModelChange={([index]) => {
          setSelectedID(index as number);
        }}
        hideFooterSelectedRowCount
        onPageChange={onPageChange}
        loading={isLoading}
        autoHeight={true}
        rowCount={rowCount}
        rows={(data?.items as any[]) ?? []}
        pageSize={10}
        rowsPerPageOptions={[10]}
        columns={headers}
      />
      <div style={{ position: "absolute", bottom: 10, left: 10 }}>
        {selectedID && (
          <>
            <Button
              color="danger"
              onClick={() => {
                setDeleteModalActive(true);
              }}
            >
              Delete
            </Button>
          </>
        )}
      </div>
      <Modal
        show={deleteModalActive}
        onClose={() => {
          setDeleteModalActive(false);
        }}
        onAction={async () => {
          if (!selectedID) {
            return;
          }
          await commentsApi.delete(selectedID);
          modifyData(selectedID, null);
          toast.success("Comment deleted");
        }}
      >
        <p>Comment will be deleted (cannot be undone)</p>
      </Modal>
    </div>
  );
}

export default CommentsTable;
