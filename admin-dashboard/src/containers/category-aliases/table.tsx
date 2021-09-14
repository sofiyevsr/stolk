import useTableLoader from "../../utils/hooks/table-data-loader";
import { DataGrid } from "@mui/x-data-grid";
import CategoryAliasesApi from "../../utils/api/categories-aliases";

function CategoryAliasesTable() {
  const categoryAliasesApi = new CategoryAliasesApi();
  const getAll = async ({ lastID }: { lastID: number | null }) => {
    const {
      body: { categories },
    }: any = await categoryAliasesApi.getAll({ lastID });
    return { items: categories, hasReachedEnd: true };
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
      columns={headers}
      rowsPerPageOptions={[10]}
    />
  );
}

export default CategoryAliasesTable;
