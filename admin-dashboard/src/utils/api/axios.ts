import axios, { AxiosRequestConfig } from "axios";
import { toast } from "react-toastify";
import storageService from "../storage";
import { store as redux } from "../../redux/store";
import { logout } from "../../redux/slices/user";
import { API_URL } from "../constants";

const axiosConfig: AxiosRequestConfig = {
  baseURL: API_URL,
  headers: { "Content-Type": "application/json" },
};
class CustomAxios {
  private axios = axios.create(axiosConfig);
  private storage = new storageService();

  constructor() {
    this.axios.interceptors.request.use(
      (config) => {
        const { user } = redux.getState();
        if (user.isAuthorized === true && user.data) {
          config.headers["Authorization"] = `Bearer ${user.data.token}`;
        }
        return config;
      },
      (error) => {
        return Promise.reject(error);
      }
    );
    this.axios.interceptors.response.use(
      (res) => {
        if (res.status === 201 && res.data.message) {
          toast("Məlumat yaradıldı", { type: "success" });
        }
        return res;
      },
      (error) => {
        // Unauthorized
        if (error.response?.status === 401) {
          this.storage.logout();
          redux.dispatch(logout());
        }
        toast("Xəta", { type: "error" });
        return Promise.reject(error);
      }
    );
  }

  public async get<T>(
    url: string,
    params: AxiosRequestConfig["params"]
  ): Promise<T> {
    let config: AxiosRequestConfig = { params };
    const res = await this.axios.get(url, config);
    return res.data;
  }

  public async post<T>(
    url: string,
    data: AxiosRequestConfig["data"],
    headers: AxiosRequestConfig["headers"] = {}
  ): Promise<T> {
    const res = await this.axios.post(url, data, {
      headers,
    });
    return res.data;
  }

  public async put<T>(
    url: string,
    data: AxiosRequestConfig["data"],
    headers: AxiosRequestConfig["headers"] = {}
  ): Promise<T> {
    const res = await this.axios.put(url, data, {
      headers,
    });
    return res.data;
  }

  public async patch<T>(
    url: string,
    data: AxiosRequestConfig["data"],
    headers: AxiosRequestConfig["headers"] = {}
  ): Promise<T> {
    const res = await this.axios.patch(url, data, {
      headers,
    });
    return res.data;
  }

  public async delete<T>(
    url: string,
    data: AxiosRequestConfig["data"]
  ): Promise<T> {
    let config: AxiosRequestConfig = { data };
    const res = await this.axios.delete(url, config);
    return res.data;
  }
}
export default CustomAxios;
