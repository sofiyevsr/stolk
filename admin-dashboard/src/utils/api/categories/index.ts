import { IPaginate, TableInterface } from "../@types/paginate";
import ApiClient from "../apiClient";

type CategoriesResponse = {
  email: string;
  first_name: string;
  last_name: string;
  token: string;
};

class CategoriesApi extends ApiClient implements TableInterface {
  public async getAll({ limit, page }: IPaginate) {
    const data = await this.axios.get<CategoriesResponse>("/sources", {
      limit,
      page,
    });
    return data;
  }
}

export default CategoriesApi;
