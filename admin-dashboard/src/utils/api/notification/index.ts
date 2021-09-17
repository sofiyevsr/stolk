import { IPaginate, TableInterface } from "../@types/paginate";
import ApiClient from "../apiClient";

class NotificationApi extends ApiClient {
  public async sendThroughNewsTopic({
    title,
    body,
  }: {
    title: string;
    body: string;
  }) {
    const data = await this.axios.post("/notification/send/news", {
      title,
      body,
    });
    return data;
  }
}

export default NotificationApi;
