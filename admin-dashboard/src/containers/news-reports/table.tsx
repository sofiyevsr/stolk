import useTableLoader from "../../utils/hooks/table-data-loader";
import NewsReportsApi from "../../utils/api/news-reports";
import StyledDataGrid from "../../components/data-grid/dataGrid";

function NewsReportsTable() {
  const newsReportsApi = new NewsReportsApi();
  const getAll = async ({ lastID }: { lastID: number | null }) => {
    const {
      body: { reports, has_reached_end },
    }: any = await newsReportsApi.getAll({ lastID });
    return { items: reports, hasReachedEnd: has_reached_end };
  };
  const { data, rowCount, headers, isLoading, onPageChange } = useTableLoader({
    fetchData: getAll as any,
  });
  return (
    <StyledDataGrid
      onPageChange={onPageChange}
      loading={isLoading}
      autoHeight={true}
      rowCount={rowCount}
      rows={(data?.items as any[]) ?? []}
      pageSize={10}
      columns={headers}
      rowsPerPageOptions={[10]}
    />
  );
}

export default NewsReportsTable;
