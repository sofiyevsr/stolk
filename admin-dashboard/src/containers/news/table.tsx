import useTableLoader from "../../utils/hooks/table-data-loader";
import { DataGrid } from "@mui/x-data-grid";
import NewsApi from "../../utils/api/news";
import { useState } from "react";
import { Button, Modal } from "../../widgets";
import { toast } from "react-toastify";
import NotificationApi from "../../utils/api/notification";

const newsApi = new NewsApi();
const notificationApi = new NotificationApi();
function NewsTable() {
  const getAll = async ({ lastID }: { lastID: number | null }) => {
    const {
      body: { news, has_reached_end },
    }: any = await newsApi.getAll({ lastID });
    return { items: news, hasReachedEnd: has_reached_end };
  };
  const { data, rowCount, headers, isLoading, onPageChange, modifyData } =
    useTableLoader({
      fetchData: getAll as any,
    });
  const [actionType, setActionType] = useState<"hide" | "unhide">();
  const [selectedID, setSelectedID] = useState<number>();
  const [sendingNotification, setSendingNotification] = useState(false);

  return (
    <div style={{ position: "relative" }}>
      <DataGrid
        onPageChange={onPageChange}
        onSelectionModelChange={([index]) => {
          setSelectedID(index as number);
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
        {selectedID && (
          <>
            <Button
              color="danger"
              mr={1}
              onClick={() => {
                setActionType("hide");
              }}
            >
              Hide
            </Button>
            <Button
              color="success"
              mr={1}
              onClick={() => {
                setActionType("unhide");
              }}
            >
              Unhide
            </Button>
            <Button
              color="info"
              disabled={sendingNotification}
              onClick={async () => {
                setSendingNotification(true);
                try {
                  const { body } = await notificationApi.sendNewsToEveryone(
                    selectedID
                  );
                  toast.success(`Notifications sent,
                    \nsuccess: ${body.success_count}
                    \nfailure: ${body.failure_count}
                    \ndeleted stale tokens: ${body.deleted_count}`);
                } catch (_) {
                } finally {
                  setSendingNotification(false);
                }
              }}
            >
              Send to everyone as notification
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
          if (actionType === "hide") {
            const {
              body: { hidden_at },
            } = await newsApi.hide(selectedID);
            modifyData(selectedID, { hidden_at });
            toast.success("News hidden");
          } else {
            await newsApi.unhide(selectedID);
            modifyData(selectedID, { hidden_at: null });
            toast.success("News recovered");
          }
        }}
      >
        <p>News will be {actionType === "hide" ? "hidden" : "unhidden"}</p>
      </Modal>
    </div>
  );
}

export default NewsTable;
