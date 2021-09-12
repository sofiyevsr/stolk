import { login, logout } from "../../../redux/slices/user";
import StorageService from "../../storage";
import ApiClient from "../apiClient";

type LoginResponse = {
  email: string;
  first_name: string;
  last_name: string;
  token: string;
};

type CheckTokenResponse = LoginResponse;

class AuthApi extends ApiClient {
  private storage = new StorageService();
  public async login(email: string, password: string) {
    const data = await this.axios.post<LoginResponse>(
      "/login",
      {
        email,
        password,
      },
      undefined
    );
    login({
      email: data.email,
      token: data.token,
      last_name: data.last_name,
      first_name: data.first_name,
    });
    return data;
  }

  public async logout() {
    const data = await this.axios.post<{}>("/logout", {});
    logout();
    return data;
  }

  public async checkToken(): Promise<CheckTokenResponse | null> {
    const token = this.storage.getToken();
    if (token != null) {
      logout();
      return null;
    }
    const data = await this.axios.post<CheckTokenResponse>(
      "/check-token",
      {},
      {
        Authorization: `Bearer ${token}`,
      }
    );
    login({
      token: data.token,
      first_name: data.first_name,
      last_name: data.last_name,
      email: data.email,
    });
    return data;
  }
}

export default AuthApi;
