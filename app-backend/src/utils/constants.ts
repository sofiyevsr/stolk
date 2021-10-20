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
// Means 3 account can be created in 5 minutes
export const newRegistrationBackoffMinutes = 5;
export const newRegistrationBackoffCounts = 3;
// Means 10 comments per minute
export const newCommentsBackoffMinutes = 1;
export const newCommentsBackoffCounts = 10;
// How many tokens can user save
export const newFCMTokenBackoffCounts = 10;

export const passwordRegex =
  /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d@$!%*?&_^-]{7,}$/;

export enum NewsSortBy {
  POPULAR,
  LATEST,
  MOST_LIKED,
  MOST_READ,
}

export enum ServiceType {
  GOOGLE,
  APPLE,
  FACEBOOK,
}

export enum NotificationOptoutType {
  // Unless user optouts latest news from one of sources user follow will be sent each ... days
  SourceFollow,
  // Channel for sending notifications through admin panel
  Updates,
}

export enum SessionType {
  IOS,
  ANDROID,
}

export const sessionTypeToString = (p: SessionType) => {
  if (p === SessionType.IOS) {
    return "IOS";
  }
  if (p === SessionType.ANDROID) {
    return "ANDROID";
  }
  return "";
};

export type IJWTUser = {
  id: number;
  platform: SessionType;
};

export const tables = {
  language: "language",
  service_type: "service_type",
  base_user: "base_user",
  app_user: "app_user",
  oauth_user: "oauth_user",
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
  read_news: "read_news",
  comment_news: "comment_news",
  uncomment_news: "uncomment_news",
  like_news: "like_news",
  unlike_news: "unlike_news",
};

export const triggers = {
  read_trigger: "read_trigger",
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
