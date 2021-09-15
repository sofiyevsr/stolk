import useTableLoader from "../../utils/hooks/table-data-loader";
import { DataGrid } from "@mui/x-data-grid";
import CategoriesApi from "../../utils/api/categories";
import AddCategoryModal from "./addModal";
import { useState } from "react";
import { Button, Modal } from "../../widgets";
import { toast } from "react-toastify";

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
  const [selectedID, setSelectedID] = useState<number>();
  const [deleteModalActive, setDeleteModalActive] = useState(false);
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
        <Modal
          show={deleteModalActive}
          onClose={() => {
            setDeleteModalActive(false);
          }}
          onAction={async () => {
            if (!selectedID) {
              return;
            }
            await categoriesApi.delete(selectedID);
            modifyData(selectedID, null);
            toast.success("Category deleted");
          }}
        >
          <p>
            Category will be deleted (cannot be undone, referencing links from
            category alias will be broken)
          </p>
        </Modal>
      </div>
    </div>
  );
}

export default CategoriesTable;
