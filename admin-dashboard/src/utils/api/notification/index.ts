import ApiClient from "../apiClient";

class NotificationApi extends ApiClient {
  public async sendToEveryone({
    title,
    body,
  }: {
    title: string;
    body: string;
  }) {
    const data = await this.axios.post("/notification/send", {
      title,
      body,
    });
    return data;
  }
}

export default NotificationApi;
