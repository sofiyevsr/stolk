import useTableLoader from "../../utils/hooks/table-data-loader";
import { DataGrid } from "@mui/x-data-grid";
import UsersApi from "../../utils/api/users";
import { useState } from "react";
import { Button, Modal } from "../../widgets";
import {toast} from "react-toastify";

const usersApi = new UsersApi();
function UsersTable() {
  const getAll = async ({ lastID }: { lastID: number | null }) => {
    const {
      body: { users, has_reached_end },
    }: any = await usersApi.getAll({ lastID });
    return { items: users, hasReachedEnd: has_reached_end };
  };
  const { data, rowCount, headers, isLoading, onPageChange, modifyData } =
    useTableLoader({
      fetchData: getAll as any,
    });
  const [actionType, setActionType] = useState<"ban" | "unban">();
  const [selectedID, setSelectedID] = useState<number>();

  return (
    <div style={{ position: "relative" }}>
      <DataGrid
        onSelectionModelChange={([index]) => {
          if (index) setSelectedID(index as number);
        }}
        hideFooterSelectedRowCount
        onPageChange={onPageChange}
        loading={isLoading}
        autoHeight={true}
        rows={(data?.items as any[]) ?? []}
        pageSize={10}
        rowsPerPageOptions={[10]}
        rowCount={rowCount}
        columns={headers}
      />
      <div style={{ position: "absolute", bottom: 10, left: 10 }}>
        {selectedID && (
          <>
            <Button
              color="danger"
              mr={1}
              onClick={() => {
                setActionType("ban");
              }}
            >
              Ban
            </Button>
            <Button
              color="success"
              onClick={() => {
                setActionType("unban");
              }}
            >
              Unban
            </Button>
          </>
        )}
      </div>
      <Modal
        show={!!actionType && !!selectedID}
        onClose={() => {
          setActionType(undefined);
        }}
        onAction={async () => {
          if (!selectedID) {
            return;
          }
          if (actionType === "ban") {
            const {
              body: { banned_at },
            } = await usersApi.ban(selectedID);
            modifyData(selectedID, { banned_at });
            toast.success("User banned");
          } else {
            await usersApi.unban(selectedID);
            modifyData(selectedID, { banned_at: null });
            toast.success("User unbanned");
          }
        }}
      >
        <p>User will be {actionType === "ban" ? "banned" : "unbanned"}</p>
      </Modal>
    </div>
  );
}

export default UsersTable;
