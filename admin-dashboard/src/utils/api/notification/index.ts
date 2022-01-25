import ApiClient from "../apiClient";

interface Response {
  body: {
    success_count: number;
    failure_count: number;
    deleted_count: number;
  };
}

class NotificationApi extends ApiClient {
  public async sendToEveryone({
    title,
    body,
  }: {
    title: string;
    body: string;
  }) {
    const data = await this.axios.post<Response>("/notification/send", {
      title,
      body,
    });
    return data;
  }
  public async sendNewsToEveryone(id: number) {
    const data = await this.axios.post<Response>("/notification/send-news", {
      id,
    });
    return data;
  }
}

export default NotificationApi;
