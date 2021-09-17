import db from "@config/db/db";
import { materializedViews } from "@utils/constants";

async function all() {
  const sourceData = await db
    .select(
      "id",
      "name",
      "like_count",
      "comment_count",
      "news_count",
      "read_count",
      "follow_count"
    )
    .from(materializedViews.analytics_by_source);
  const categoryData = await db
    .select(
      "id",
      "name",
      "like_count",
      "comment_count",
      "news_count",
      "read_count"
    )
    .from(materializedViews.analytics_by_category);
  const overallData = await db
    .select("news_count", "user_count")
    .from(materializedViews.analytics_by_overall);
  return { overallData, categoryData, sourceData };
}

export default {
  all,
};
