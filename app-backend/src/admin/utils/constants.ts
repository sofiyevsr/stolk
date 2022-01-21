export const PAGINATION_LIMIT = 10;
export type IJWTUser = {
  id: number;
};
export const assetsBucket =
  process.env.NODE_ENV === "production"
    ? "assets.stolk.app"
    : "development_stolk";
