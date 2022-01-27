import { IPaginate, TableInterface } from "../@types/paginate";
import ApiClient from "../apiClient";

type SourceRequest = {
  name: string;
  id: number;
  logo_suffix: string;
  link: string;
  image: File;
  lang_id: string;
  category_alias_name?: string;
};

class SourcesApi extends ApiClient implements TableInterface {
  public async getAll({ lastID }: IPaginate) {
    const data = await this.axios.get("/source", {
      last_id: lastID,
    });
    return data;
  }

  public async update({
    name,
    id,
    logo_suffix,
    link,
    image,
    lang_id,
    category_alias_name,
  }: SourceRequest) {
    const formData = new FormData();
    formData.append("name", name);
    formData.append("image", image);
    formData.append("link", link);
    formData.append("lang_id", lang_id);
    formData.append("logo_suffix", logo_suffix);
    if (category_alias_name != null && category_alias_name.trim() !== "")
      formData.append("category_alias_name", category_alias_name);
    const data = await this.axios.patch(`/source/${id}`, formData, {
      "Content-Type": "multipart/form-data",
    });
    return data;
  }

  public async create({
    name,
    logo_suffix,
    link,
    image,
    lang_id,
    category_alias_name,
  }: Omit<SourceRequest, "id">) {
    const formData = new FormData();
    formData.append("name", name);
    formData.append("image", image);
    formData.append("link", link);
    formData.append("lang_id", lang_id);
    formData.append("logo_suffix", logo_suffix);
    if (category_alias_name != null && category_alias_name.trim() !== "")
      formData.append("category_alias_name", category_alias_name);

    const data = await this.axios.post(`/source`, formData, {
      "Content-Type": "multipart/form-data",
    });
    return data;
  }

  public async delete(id: number) {
    const data = await this.axios.delete(`/source/${id}`, {});
    return data;
  }
}

export default SourcesApi;
