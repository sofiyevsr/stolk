import { GridColDef, GridColumns } from "@mui/x-data-grid";
import qs from "qs";
import { useEffect, useMemo, useRef, useState } from "react";
import { useHistory } from "react-router-dom";

type DataType<T> = {
  hasReachedEnd: boolean;
  items: T[];
};

type Props = {
  fetchData: <T>({ lastID }: { lastID: number | null }) => Promise<DataType<T>>;
  isFullScan?: boolean;
};

function useTableLoader<T>({ fetchData, isFullScan = false }: Props) {
  const [data, setData] = useState<DataType<T>>();
  const [isLoading, setLoading] = useState(true);
  const history = useHistory();
  const lastPage = useRef(0);
  useEffect(() => {
    const { last_id } = qs.parse(history.location.search, {
      ignoreQueryPrefix: true,
    });
    if (last_id != null) {
      const parsedID = Number.parseInt(last_id as string);
      if (Number.isNaN(parsedID)) return;
    }
    retrieveData(last_id ? Number.parseInt(last_id as string) : null);
  }, [history.location]);

  const retrieveData = (lastID: number | null) => {
    setLoading(true);
    fetchData<T>({ lastID })
      .then((response) => {
        if (lastID == null) {
          // Reset pages when last_id is null
          lastPage.current = 0;
          setData(response);
        } else
          setData({
            hasReachedEnd: response.hasReachedEnd,
            items: [...(data?.items ?? []), ...response.items],
          });
        setLoading(false);
      })
      .catch((_) => {
        /* setLoading(false); */
      });
  };

  const onPageChange = (index: number) => {
    if (isFullScan || lastPage.current > index) {
      return;
    }
    if (data) {
      const id = (data.items[data.items.length - 1] as any).id;
      history.push("?last_id=" + id);
      lastPage.current = index;
    }
  };

  const headers: GridColumns = useMemo(() => {
    if (!data || data.items.length === 0) {
      return [];
    }
    return Object.keys(data.items[0]).map(
      (d): GridColDef => ({ field: d, width: 200 })
    );
  }, [data]);

  return {
    data,
    isLoading,
    headers,
    onPageChange,
  };
}

export default useTableLoader;
