import useTableLoader from "../../utils/hooks/table-data-loader";
import { DataGrid } from "@mui/x-data-grid";
import CategoryAliasesApi from "../../utils/api/categories-aliases";
import { Button, Modal } from "../../widgets";
import LinkCategoryModal from "./link";
import { useState } from "react";

function CategoryAliasesTable() {
  const categoryAliasesApi = new CategoryAliasesApi();
  const getAll = async ({ lastID }: { lastID: number | null }) => {
    const {
      body: { categories },
    }: any = await categoryAliasesApi.getAll({ lastID });
    return { items: categories, hasReachedEnd: true };
  };
  const { data, headers, isLoading, onPageChange, modifyData } = useTableLoader(
    {
      fetchData: getAll as any,
      isFullScan: true,
    }
  );
  const [selectedID, setSelectedID] = useState<number>();
  const [showModal, setShowModal] = useState(false);

  return (
    <div style={{ position: "relative" }}>
      <DataGrid
        onPageChange={onPageChange}
        loading={isLoading}
        onSelectionModelChange={([index]) => {
          setSelectedID(index as number);
        }}
        hideFooterSelectedRowCount
        autoHeight={true}
        rows={(data?.items as any[]) ?? []}
        pageSize={10}
        columns={headers.map((d) => ({
          ...d,
          sortable: true,
          filterable: true,
        }))}
        rowsPerPageOptions={[10]}
      />
      <div style={{ position: "absolute", bottom: 10, left: 10 }}>
        {selectedID && (
          <>
            <Button
              color="success"
              onClick={() => {
                setShowModal(true);
              }}
            >
              Link
            </Button>
            <LinkCategoryModal
              show={showModal}
              categoryAliasID={selectedID}
              alterInMemory={({ category_id }) => {
                modifyData(selectedID, { category_id });
              }}
              onClose={() => {
                setShowModal(false);
              }}
            />
          </>
        )}
      </div>
    </div>
  );
}

export default CategoryAliasesTable;
