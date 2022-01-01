import useTableLoader from "../../utils/hooks/table-data-loader";
import SourcesApi from "../../utils/api/sources";
import { DataGrid } from "@mui/x-data-grid";
import { useState } from "react";
import { toast } from "react-toastify";
import { Button, Modal } from "../../widgets";
import ActionsModal from "./actionsModal";

type Props = {
  show: boolean;
  setModalActive: React.Dispatch<boolean>;
};

const sourcesApi = new SourcesApi();

function SourcesTable({ setModalActive, show }: Props) {
  const getAll = async ({ lastID }: { lastID: number | null }) => {
    const {
      body: { sources },
    }: any = await sourcesApi.getAll({ lastID });
    return { items: sources, hasReachedEnd: true };
  };
  const { addItem, data, modifyData, headers, isLoading, onPageChange } =
    useTableLoader({
      fetchData: getAll as any,
      isFullScan: true,
    });
  const [actionType, setActionType] = useState<"delete" | "update">();
  const [selectedID, setSelectedID] = useState<number>();

  return (
    <div style={{ position: "relative" }}>
      <DataGrid
        onSelectionModelChange={([index]) => {
          setSelectedID(index as number);
        }}
        onPageChange={onPageChange}
        loading={isLoading}
        autoHeight={true}
        rows={(data?.items as any[]) ?? []}
        pageSize={10}
        rowsPerPageOptions={[10]}
        columns={headers.map((d) => ({
          ...d,
          sortable: true,
          filterable: true,
        }))}
      />
      <ActionsModal
        addItem={addItem}
        modifyItem={modifyData}
        show={show}
        onClose={() => {
          setModalActive(false);
        }}
      />
      <ActionsModal
        show={!!actionType && actionType === "update" && !!selectedID}
        onClose={() => {
          setActionType(undefined);
        }}
        sourceID={selectedID}
        addItem={addItem}
        modifyItem={modifyData}
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
          if (actionType === "delete") {
            await sourcesApi.delete(selectedID);
            modifyData(selectedID, null);
            toast.success("Source deleted");
          }
        }}
      >
        {actionType === "delete" && (
          <p>Source will be deleted (cannot be undone) </p>
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

export default SourcesTable;
