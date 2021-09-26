// LINKS
export const websiteLink = "https://stolk.app/";
export const forgotPasswordLink = websiteLink + "reset-password/";
export const emailConfirmationLink = websiteLink + "email-confirmation/";
export const emailAssetS3Link =
  "https://stolk.s3.eu-west-3.amazonaws.com/email-images/";

// LIMITS
export const resetTokenExpirationMinutes = 60;
export const resetTokenBackoffMinutes = 3;
export const confirmationTokenBackoffMinutes = 3;

export const passwordRegex =
  /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d@$!%*?&_^-]{7,}$/;

export enum AppPlatform {
  IOS,
  ANDROID,
}

export enum ServiceType {
  APP,
  GOOGLE,
  APPLE,
}

export enum NotificationOptoutType {
  // Unless user optouts latest news from one of sources user follow will be sent each ... days
  SourceFollow,
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
  admin_user: "admin_user",
  user_session: "user_session",
  session_type: "session_type",
  report: "report",
  news_report: "news_report",
  comment_report: "comment_report",
  reset_token: "reset_token",
  confirmation_token: "confirmation_token",
  news_feed: "news_feed",
  news_source: "news_source",
  news_category: "news_category",
  news_category_alias: "news_category_alias",
  news_like: "news_like",
  news_bookmark: "news_bookmark",
  source_follow: "source_follow",
  notification_token: "notification_token",
  news_comment: "news_comment",
  news_read_history: "news_read_history",
  notification_type: "notification_type",
  notification_optout: "notification_optout",
};

export const functions = {
  comment_news: "comment_news",
  uncomment_news: "uncomment_news",
  like_news: "like_news",
  unlike_news: "unlike_news",
};

export const triggers = {
  comment_trigger: "comment_trigger",
  uncomment_trigger: "uncomment_trigger",
  like_trigger: "like_trigger",
  unlike_trigger: "unlike_trigger",
};

export const materializedViews = {
  analytics_by_source: "analytics_by_source",
  analytics_by_category: "analytics_by_category",
  analytics_by_overall: "analytics_by_overall",
};

export const notification_topics = {
  news: "news",
};

export const DEFAULT_PERPAGE = 10;
export const MAX_PERPAGE = 30;
export const MAX_CATEGORIES_COUNT = 5;
