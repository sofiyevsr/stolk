import { IPaginate, TableInterface } from "../@types/paginate";
import ApiClient from "../apiClient";

interface AllResponse {
  body: { categories: { id: number; name: string; created_at: string }[] };
}

interface HiddenResponse {
  body: {
    hidden_at: string | null;
  };
}

interface InsertCategoryRequest {
  name: string;
  image_suffix: string;
}

interface UpdateCategoryRequest {
  name: string;
  image_suffix: string;
  id: number;
}

class CategoriesApi extends ApiClient implements TableInterface {
  public async getAll({ lastID }: IPaginate) {
    const data = await this.axios.get<AllResponse>("/news/categories", {
      last_id: lastID,
    });
    return data;
  }
  public async insert({ name, image_suffix }: InsertCategoryRequest) {
    const data = await this.axios.post(`/news/category`, {
      name,
      image_suffix,
    });
    return data;
  }

  public async update({ name, id, image_suffix }: UpdateCategoryRequest) {
    const data = await this.axios.patch(`/news/category/${id}`, {
      name,
      image_suffix,
    });
    return data;
  }

  public async delete(id: number) {
    const data = await this.axios.delete(`/news/category/${id}`, {});
    return data;
  }

  public async hide(id: number) {
    const data = await this.axios.patch<HiddenResponse>(
      `/news/category/${id}/hide`,
      {}
    );
    return data;
  }

  public async unhide(id: number) {
    const data = await this.axios.patch(`/news/category/${id}/unhide`, {});
    return data;
  }
}

export default CategoriesApi;
