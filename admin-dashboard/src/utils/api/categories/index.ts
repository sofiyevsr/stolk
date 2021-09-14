import { IPaginate, TableInterface } from "../@types/paginate";
import ApiClient from "../apiClient";

class CategoriesApi extends ApiClient implements TableInterface {
  public async getAll({ lastID }: IPaginate) {
    const data = await this.axios.get("/news/categories", {
      last_id: lastID,
    });
    return data;
  }
}

export default CategoriesApi;
