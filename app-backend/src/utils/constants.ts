export const tokenExpirationMinutes = 60;

export enum AppPlatform {
  IOS,
  ANDROID,
}

export enum ServiceType {
  APP,
}

export enum SessionType {
  IOS,
  ANDROID,
}

export const platformToName = (p: AppPlatform) => {
  if (p === AppPlatform.IOS) {
    return "IOS";
  }
  if (p === AppPlatform.ANDROID) {
    return "ANDROID";
  }
  return "";
};

export type IJWTUser = {
  id: number;
  platform: AppPlatform;
};

export const tables = {
  language: "language",
  service_type: "service_type",
  app_user: "app_user",
  user_session: "user_session",
  session_type: "session_type",
  reset_token: "reset_token",
  news_feed: "news_feed",
  news_source: "news_source",
  news_category: "news_category",
  news_category_alias: "news_category_alias",
  news_like: "news_like",
  news_bookmark: "news_bookmark",
  notification_token: "notification_token",
};

export const notification_topics = {
  news: "news",
};

// Used for pagination of campaigns and business
export const DEFAULT_PERPAGE = 10;
export const MAX_PERPAGE = 30;
