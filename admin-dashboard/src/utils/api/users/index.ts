import { IPaginate, TableInterface } from "../@types/paginate";
import ApiClient from "../apiClient";

class UsersApi extends ApiClient implements TableInterface {
  public async getAll({ lastID }: IPaginate) {
    const data = await this.axios.get("/users", {
      last_id: lastID,
    });
    return data;
  }
}

export default UsersApi;
