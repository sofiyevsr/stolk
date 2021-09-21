import { IPaginate, TableInterface } from "../@types/paginate";
import ApiClient from "../apiClient";

class SourcesApi extends ApiClient implements TableInterface {
  public async getAll({ lastID }: IPaginate) {
    const data = await this.axios.get("/source", {
      last_id: lastID,
    });
    return data;
  }
}

export default SourcesApi;
