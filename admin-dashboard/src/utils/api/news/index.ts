import { IPaginate, TableInterface } from "../@types/paginate";
import ApiClient from "../apiClient";

class NewsApi extends ApiClient implements TableInterface {
  public async getAll({ lastID }: IPaginate) {
    const data = await this.axios.get("/news/all", {
      last_id: lastID,
    });
    return data;
  }
}

export default NewsApi;
