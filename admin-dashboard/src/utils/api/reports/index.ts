import { IPaginate, TableInterface } from "../@types/paginate";
import ApiClient from "../apiClient";

type SourcesResponse = {
  email: string;
  first_name: string;
  last_name: string;
  token: string;
};

class SourcesApi extends ApiClient implements TableInterface {
  public async getAll({ limit, page }: IPaginate) {
    const data = await this.axios.get<SourcesResponse>("/sources", {
      limit,
      page,
    });
    return data;
  }
}

export default SourcesApi;
