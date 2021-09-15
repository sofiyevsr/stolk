import { IPaginate, TableInterface } from "../@types/paginate";
import ApiClient from "../apiClient";

interface AllResponse {
  body: { categories: { id: number; name: string; created_at: string }[] };
}

class CategoriesApi extends ApiClient implements TableInterface {
  public async getAll({ lastID }: IPaginate) {
    const data = await this.axios.get<AllResponse>("/news/categories", {
      last_id: lastID,
    });
    return data;
  }
  public async insert({ name }: { name: string }) {
    const data = await this.axios.post(`/news/category`, { name });
    console.log(data);
    return data;
  }

  public async delete(id: number) {
    const data = await this.axios.delete(`/news/category/${id}`, {});
    return data;
  }
}

export default CategoriesApi;
