import db from "@config/db/db";
import { materializedViews } from "@utils/constants";

async function refresh() {
  const sourceData = await db.raw(
    `REFRESH MATERIALIZED VIEW ${materializedViews.analytics_by_source} WITH DATA`
  );
  const categoryData = await db.raw(
    `REFRESH MATERIALIZED VIEW ${materializedViews.analytics_by_category} WITH DATA`
  );
  const overallData = await db.raw(
    `REFRESH MATERIALIZED VIEW ${materializedViews.analytics_by_overall} WITH DATA`
  );

  return { overallData, categoryData, sourceData };
}

export default refresh;
