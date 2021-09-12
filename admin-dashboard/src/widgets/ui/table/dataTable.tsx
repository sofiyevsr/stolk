import { CDataTable } from "@coreui/react";
import Joi from "joi";
import qs from "qs";
import { useEffect, useRef, useState } from "react";
import { useHistory, useLocation } from "react-router-dom";
import { TableInterface } from "../../../utils/api/@types/paginate";

const defaults = {
  filter: false,
  sorter: false,
};

interface Props {
  headerNames: {
    key?: string;
    label?: string;
    _style?: { width: string };
    filter?: boolean;
    sorter?: boolean;
  }[];
  apiClient: TableInterface;
}

const validation = Joi.object({
  page: Joi.number().min(1).max(1000),
  limit: Joi.number().valid(10, 20),
  /* sortBy: Joi.string().valid("asc", "desc"), */
  /* sortField: Joi.string(), */
}).options({ stripUnknown: true });

function DataTable({ apiClient, headerNames }: Props) {
  const [data, setData] = useState<
    { id: string | number; [key: string]: any }[]
  >([]);
  const isMounted = useRef<boolean>(true);
  const location = useLocation();
  const router = useHistory();

  useEffect(() => {
    apiClient
      .getAll({ lastID: data[data.length - 1].id })
      .then((data) => {
        if (isMounted.current === true) setData(data);
      })
      .catch((_) => {});
    return () => {
      isMounted.current = false;
    };
  }, [pageConfig]);

  useEffect(() => {
    if (location.search === "") return;
    const data = qs.parse(location.search, { ignoreQueryPrefix: true });
    const config: Pagination = { ...defaultConfig };
    const { error, value } = validation.validate(data);
    if (error) return;
    if (isMounted.current === true) setPageConfig({ ...config, ...value });
  }, [location.search]);

  return (
    <CDataTable
      items={[{ test: 1 }]}
      hover
      loading={false}
      striped
      pagination
      itemsPerPageSelect={{
        values: [10, 20],
      }}
      itemsPerPage={pageConfig.limit}
      activePage={pageConfig.page}
      sorter={false}
      onPaginationChange={(limit: number) => {
        const config = { ...pageConfig };

        if (config["limit"] === limit) return;

        config["limit"] = limit;

        router.push({
          search: qs.stringify(config),
        });
      }}
      onPageChange={(page: number) => {
        const config = { ...pageConfig };

        if (config["page"] === page) return;

        config["page"] = page;

        router.push({
          search: qs.stringify(config),
        });
      }}
    />
  );
}

export default DataTable;
