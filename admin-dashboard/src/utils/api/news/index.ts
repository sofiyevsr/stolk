import { IPaginate, TableInterface } from "../@types/paginate";
import ApiClient from "../apiClient";

interface HiddenResponse {
  body: {
    hidden_at: string | null;
  };
}

class NewsApi extends ApiClient implements TableInterface {
  public async getAll({ lastID }: IPaginate) {
    const data = await this.axios.get("/news/all", {
      last_id: lastID,
    });
    return data;
  }
  public async hide(id: number) {
    const data = await this.axios.patch<HiddenResponse>(`/news/${id}/hide`, {});
    return data;
  }
  public async unhide(id: number) {
    const data = await this.axios.patch<HiddenResponse>(
      `/news/${id}/unhide`,
      {}
    );
    return data;
  }
}

export default NewsApi;
