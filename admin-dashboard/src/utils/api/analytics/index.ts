import ApiClient from "../apiClient";

export interface AllAnalyticsResponse {
  body: {
    overallData: {
      news_count: number;
      user_count: number;
    }[];
    categoryData: {
      id: number;
      name: string;
      like_count: number;
      comment_count: number;
      news_count: number;
      read_count: number;
    }[];
    sourceData: {
      id: number;
      name: string;
      like_count: number;
      comment_count: number;
      news_count: number;
      read_count: number;
      follow_count: number;
    }[];
  };
}

class AnalyticsApi extends ApiClient {
  public async getAll() {
    const data = await this.axios.get<AllAnalyticsResponse>(
      "/analytics/all",
      {}
    );
    return data;
  }
  public async refresh() {
    const data = await this.axios.post("/analytics/refresh", {});
    return data;
  }
}

export default AnalyticsApi;
