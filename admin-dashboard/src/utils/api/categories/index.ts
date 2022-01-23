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
  name_en: string;
  name_ru: string;
  name_az: string;
  image_suffix: string;
  image: File;
}

interface UpdateCategoryRequest extends InsertCategoryRequest {
  id: number;
}

class CategoriesApi extends ApiClient implements TableInterface {
  public async getAll({ lastID }: IPaginate) {
    const data = await this.axios.get<AllResponse>("/news/categories", {
      last_id: lastID,
    });
    return data;
  }
  public async insert({
    name_az,
    name_ru,
    name_en,
    image,
    image_suffix,
  }: InsertCategoryRequest) {
    const formData = new FormData();
    formData.append("name_az", name_az);
    formData.append("name_ru", name_ru);
    formData.append("name_en", name_en);
    formData.append("image_suffix", image_suffix);
    formData.append("image", image);
    const data = await this.axios.post(`/news/category`, formData, {
      "Content-Type": "multipart/form-data",
    });
    return data;
  }

  public async update({
    name_az,
    name_ru,
    name_en,
    id,
    image,
    image_suffix,
  }: UpdateCategoryRequest) {
    const formData = new FormData();
    formData.append("name_az", name_az);
    formData.append("name_ru", name_ru);
    formData.append("name_en", name_en);
    formData.append("image_suffix", image_suffix);
    formData.append("image", image);
    const data = await this.axios.patch(`/news/category/${id}`, formData, {
      "Content-Type": "multipart/form-data",
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
