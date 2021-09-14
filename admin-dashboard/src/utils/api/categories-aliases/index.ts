import { IPaginate, TableInterface } from "../@types/paginate";
import ApiClient from "../apiClient";

class CategoryAliasesApi extends ApiClient implements TableInterface {
  public async getAll({ lastID }: IPaginate) {
    const data = await this.axios.get("/news/category-aliases", {
      last_id: lastID,
    });
    return data;
  }
}

export default CategoryAliasesApi;
