import { IPaginate, TableInterface } from "../@types/paginate";
import ApiClient from "../apiClient";

class NewsReportsApi extends ApiClient implements TableInterface {
  public async getAll({ lastID }: IPaginate) {
    const data = await this.axios.get("/report/news", { last_id: lastID });
    return data;
  }
}

export default NewsReportsApi;
