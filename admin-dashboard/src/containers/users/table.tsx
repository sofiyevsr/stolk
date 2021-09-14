import useTableLoader from "../../utils/hooks/table-data-loader";
import { DataGrid } from "@mui/x-data-grid";
import UsersApi from "../../utils/api/users";

function UsersTable() {
  const usersApi = new UsersApi();
  const getAll = async ({ lastID }: { lastID: number | null }) => {
    const {
      body: { users, has_reached_end },
    }: any = await usersApi.getAll({ lastID });
    return { items: users, hasReachedEnd: has_reached_end };
  };
  const { data, headers, isLoading, onPageChange } = useTableLoader({
    fetchData: getAll as any,
  });
  return (
    <DataGrid
      onSelectionModelChange={(m) => {
        console.log(m);
      }}
      onPageChange={onPageChange}
      loading={isLoading}
      autoHeight={true}
      rows={(data?.items as any[]) ?? []}
      pageSize={10}
      rowsPerPageOptions={[10]}
      columns={headers}
    />
  );
}

export default UsersTable;
