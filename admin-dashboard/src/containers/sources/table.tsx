import useTableLoader from "../../utils/hooks/table-data-loader";
import SourcesApi from "../../utils/api/sources";
import { DataGrid } from "@mui/x-data-grid";

function SourcesTable() {
  const sourcesApi = new SourcesApi();
  const getAll = async ({ lastID }: { lastID: number | null }) => {
    const {
      body: { sources },
    }: any = await sourcesApi.getAll({ lastID });
    return { items: sources, hasReachedEnd: true };
  };
  const { data, headers, isLoading, onPageChange } = useTableLoader({
    fetchData: getAll as any,
    isFullScan: true,
  });
  return (
    <DataGrid
      onPageChange={onPageChange}
      loading={isLoading}
      autoHeight={true}
      rows={(data?.items as any[]) ?? []}
      pageSize={10}
      rowsPerPageOptions={[10]}
      columns={headers.map((d) => ({ ...d, sortable: true, filterable: true }))}
    />
  );
}

export default SourcesTable;
