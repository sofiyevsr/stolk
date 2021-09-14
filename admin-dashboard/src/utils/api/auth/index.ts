import { login, logout } from "../../../redux/slices/user";
import { store } from "../../../redux/store";
import StorageService from "../../storage";
import ApiClient from "../apiClient";

type LoginResponse = {
  body: {
    user: {
      email: string;
      first_name: string;
      last_name: string;
    };
    access_token: string;
  };
};

type CheckTokenResponse = LoginResponse;

class AuthApi extends ApiClient {
  private storage = new StorageService();
  public async login(email: string, password: string, recaptchaToken: string) {
    const { body } = await this.axios.post<LoginResponse>(
      "/auth/login",
      {
        recaptchaToken,
        email,
        password,
      },
      undefined
    );
    this.storage.login(body.access_token);
    store.dispatch(
      login({
        email: body.user.email,
        token: body.access_token,
        last_name: body.user.last_name,
        first_name: body.user.first_name,
      })
    );
    return body;
  }

  public async logout() {
    const data = await this.axios.post<{}>("/auth/logout", {});
    this.storage.logout();
    store.dispatch(logout());
    return data;
  }

  public async checkToken(): Promise<CheckTokenResponse["body"] | null> {
    const token = this.storage.getToken();
    if (token == null) {
      store.dispatch(logout());
      return null;
    }
    const { body } = await this.axios.post<CheckTokenResponse>(
      "/auth/check-token",
      {},
      {
        Authorization: `Bearer ${token}`,
      }
    );
    store.dispatch(
      login({
        email: body.user.email,
        token: token,
        last_name: body.user.last_name,
        first_name: body.user.first_name,
      })
    );
    return body;
  }
}

export default AuthApi;
