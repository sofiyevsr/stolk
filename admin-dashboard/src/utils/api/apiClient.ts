import CustomAxios from "./axios";

class ApiClient {
  protected axios = new CustomAxios();
}

export default ApiClient;
