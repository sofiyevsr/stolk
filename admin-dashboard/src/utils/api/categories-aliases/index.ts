import { IPaginate, TableInterface } from "../@types/paginate";
import ApiClient from "../apiClient";

type CategoryAliasesResponse = {
  email: string;
  first_name: string;
  last_name: string;
  token: string;
};

class CategoryAliasesApi extends ApiClient implements TableInterface {
  public async getAll({ limit, page }: IPaginate) {
    const data = await this.axios.get<CategoryAliasesResponse>(
      "/category-aliases",
      {
        limit,
        page,
      }
    );
    return data;
  }
}

export default CategoryAliasesApi;
