import useTableLoader from "../../utils/hooks/table-data-loader";
import { DataGrid } from "@mui/x-data-grid";
import CategoriesApi from "../../utils/api/categories";
import AddCategoryModal from "./addModal";
import { useState } from "react";
import { Button, Modal } from "../../widgets";
import { toast } from "react-toastify";
import UpdateCategoryModal from "./updateModal";

type Props = {
  show: boolean;
  setModalActive: React.Dispatch<boolean>;
};

function CategoriesTable({ setModalActive, show }: Props) {
  const categoriesApi = new CategoriesApi();
  const getAll = async ({ lastID }: { lastID: number | null }) => {
    const {
      body: { categories },
    }: any = await categoriesApi.getAll({ lastID });
    return { items: categories, hasReachedEnd: true };
  };
  const { data, addItem, headers, isLoading, modifyData, onPageChange } =
    useTableLoader({
      fetchData: getAll as any,
      isFullScan: true,
    });
  const [actionType, setActionType] = useState<
    "hide" | "unhide" | "delete" | "update"
  >();
  const [selectedID, setSelectedID] = useState<number>();
  return (
    <div style={{ position: "relative" }}>
      <DataGrid
        onPageChange={onPageChange}
        loading={isLoading}
        autoHeight={true}
        onSelectionModelChange={([index]) => {
          setSelectedID(index as number);
        }}
        rows={(data?.items as any[]) ?? []}
        pageSize={10}
        hideFooterSelectedRowCount
        columns={headers.map((d) => ({
          ...d,
          sortable: true,
          filterable: true,
        }))}
        rowsPerPageOptions={[10]}
      />
      <AddCategoryModal
        alterInMemory={addItem}
        show={show}
        onClose={() => {
          setModalActive(false);
        }}
      />
      <UpdateCategoryModal
        show={!!actionType && actionType === "update" && !!selectedID}
        onClose={() => {
          setActionType(undefined);
        }}
        categoryID={selectedID}
        alterInMemory={modifyData}
      />
      <Modal
        // This modal is for all actions but update
        show={!!actionType && actionType !== "update" && !!selectedID}
        onClose={() => {
          setActionType(undefined);
        }}
        onAction={async () => {
          if (!selectedID) {
            return;
          }
          if (actionType === "hide") {
            const {
              body: { hidden_at },
            } = await categoriesApi.hide(selectedID);
            modifyData(selectedID, { hidden_at });
            toast.success("Category hidden");
          } else if (actionType === "unhide") {
            await categoriesApi.unhide(selectedID);
            modifyData(selectedID, { hidden_at: null });
            toast.success("Category recovered");
          } else if (actionType === "delete") {
            await categoriesApi.delete(selectedID);
            modifyData(selectedID, null);
            toast.success("Category deleted");
          }
        }}
      >
        {actionType === "hide" && <p>Category will be hidden</p>}
        {actionType === "unhide" && <p>Category will be unhidden</p>}
        {actionType === "delete" && (
          <p>
            Category will be deleted (cannot be undone, referencing links from
            category alias will be broken)
          </p>
        )}
      </Modal>
      {selectedID && (
        <div
          style={{
            position: "absolute",
            maxWidth: "50%",
            bottom: -50,
          }}
        >
          <Button
            color="danger"
            m={1}
            onClick={() => {
              setActionType("hide");
            }}
          >
            Hide
          </Button>
          <Button
            color="success"
            m={1}
            onClick={() => {
              setActionType("unhide");
            }}
          >
            Unhide
          </Button>
          <Button
            color="danger"
            m={1}
            onClick={() => {
              setActionType("delete");
            }}
          >
            Delete
          </Button>
          <Button
            color="warning"
            m={1}
            onClick={() => {
              setActionType("update");
            }}
          >
            Update
          </Button>
        </div>
      )}
    </div>
  );
}

export default CategoriesTable;
