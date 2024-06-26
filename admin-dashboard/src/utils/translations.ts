export default {
  ip_address: "IP address",
  category_id: "Category ID",
  category_name: "Category Name",
  name_az: "Name in AZ",
  name_ru: "Name in RU",
  name_en: "Name in EN",
  alias: "Alias name",
  id: "ID",
  user_id: "User ID",
  news_id: "News ID",
  first_name: "First Name",
  last_name: "Last Name",
  email: "Email",
  banned_at: "Ban Date",
  created_at: "Creation Date",
  confirmed_at: "Confirmation Date",
  logo_suffix: "Logo link",
  image_suffix: "Image link",
  link: "Link",
  lang_id: "Language",
  language: "Language name",
  name: "Name",
  category_alias_name: "Category alias name",
  comment: "Comment",
  title: "Title",
  image_link: "Image link",
  pub_date: "Publish date",
  feed_link: "Feed link",
  like_count: "Like count",
  comment_count: "Comment count",
  hidden_at: "Hidden date",
  source_name: "Source name",
  source_logo_suffix: "Source logo",
  source_id: "Source ID",
  message: "Message",
  reporter_id: "Reporter ID",
  reporter_full_name: "Reporter name",
  commenter_full_name: "Commenter name",
  commenter_id: "Commenter ID",
  comment_id: "Comment ID",
  service_type_id: "Service type (Google, Apple, Facebook)",
  session_count: "Session count",
  notification_token_count: "Notification token count",
  latest_news_date: "Date last news found",
} as { [key: string]: string };

export const serverErrors = {
  empty_tokens: "No token found send notification to",
  invalid_token: "Invalid token",
  login_fail: "Login fail",
  news_not_found: "News not found",
  recaptcha_fail: "Recaptcha failed",
  wrong_type: "Invalid type",
  empty_image: "Empty image",
  account_banned: "Account banned",
  invalid_session_id: "Invalid session id",
  news_id_required: "News id required",
  source_id_required: "Source id required",
};
