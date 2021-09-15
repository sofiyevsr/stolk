import { IPaginate, TableInterface } from "../@types/paginate";
import ApiClient from "../apiClient";

class CategoryAliasesApi extends ApiClient implements TableInterface {
  public async getAll({ lastID }: IPaginate) {
    const data = await this.axios.get("/news/category-aliases", {
      last_id: lastID,
    });
    return data;
  }
  public async link({
    category_id,
    category_alias_id,
  }: {
    category_id: number | null;
    category_alias_id: number;
  }) {
    const data = await this.axios.patch("/news/category-aliases/link", {
      category_alias_id,
      category_id,
    });
    return data;
  }
}

export default CategoryAliasesApi;
