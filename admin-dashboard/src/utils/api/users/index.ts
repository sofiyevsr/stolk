import { IPaginate, TableInterface } from "../@types/paginate";
import ApiClient from "../apiClient";

type BanResponse = {
  body: {
    banned_at: string | null;
  };
};
class UsersApi extends ApiClient implements TableInterface {
  public async getAll({ lastID }: IPaginate) {
    const data = await this.axios.get("/users", {
      last_id: lastID,
    });
    return data;
  }
  public async ban(id: number) {
    const data = await this.axios.patch<BanResponse>(`/users/${id}/ban`, {});
    return data;
  }
  public async unban(id: number) {
    const data = await this.axios.patch<BanResponse>(`/users/${id}/unban`, {});
    return data;
  }
}

export default UsersApi;
