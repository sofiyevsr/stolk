import { IPaginate, TableInterface } from "../@types/paginate";
import ApiClient from "../apiClient";

class CommentsApi extends ApiClient implements TableInterface {
  public async getAll({ lastID }: IPaginate) {
    const data = await this.axios.get("/news/comments", { last_id: lastID });
    return data;
  }
  public async delete(id: number) {
    const data = await this.axios.delete(`/news/comments/${id}`, {});
    return data;
  }
}

export default CommentsApi;
