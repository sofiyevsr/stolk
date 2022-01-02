import { IPaginate, TableInterface } from "../@types/paginate";
import ApiClient from "../apiClient";

type SourceRequest = {
  name: string;
  id: number;
  logo_suffix: string;
  link: string;
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
    lang_id,
    category_alias_name,
  }: SourceRequest) {
    const data = await this.axios.patch(`/source/${id}`, {
      name,
      logo_suffix,
      link,
      lang_id,
      category_alias_name,
    });
    return data;
  }

  public async create({
    name,
    logo_suffix,
    link,
    lang_id,
    category_alias_name,
  }: Omit<SourceRequest, "id">) {
    const data = await this.axios.post(`/source`, {
      name,
      logo_suffix,
      link,
      lang_id,
      category_alias_name,
    });
    return data;
  }

  public async delete(id: number) {
    const data = await this.axios.delete(`/source/${id}`, {});
    return data;
  }
}

export default SourcesApi;
