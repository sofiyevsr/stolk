import { FC, useEffect, useMemo, useState } from "react";
import AnalyticsApi, {
  AllAnalyticsResponse,
} from "../../../utils/api/analytics";
import { Card, CardBody, Spinner } from "../../../widgets";
import TableChart from "../../analytics/tableChart";
import PieChart from "../../analytics/pieChart";

const analytics = new AnalyticsApi();
const Analytics: FC = () => {
  const [data, setData] = useState<AllAnalyticsResponse["body"]>();
  const [isLoading, setLoading] = useState(true);

  useEffect(() => {
    analytics
      .getAll()
      .then(({ body }) => {
        setLoading(false);
        setData(body);
      })
      .catch(() => {
        setLoading(false);
      });
  }, []);

  const lastUpdate = useMemo(
    () =>
      data && new Date(data.overallData[0].last_update).toLocaleString("en-US"),
    [data]
  );

  const general = useMemo(
    () =>
      data && [
        ["News", data.overallData[0].news_count],
        ["Users", data.overallData[0].user_count],
      ],
    [data]
  );

  const sourcesComment = useMemo(
    () =>
      data?.sourceData.map(({ name, comment_count }) => [name, comment_count]),
    [data]
  );

  const sourcesFollow = useMemo(
    () =>
      data?.sourceData.map(({ name, follow_count }) => [name, follow_count]),
    [data]
  );

  const sourcesLike = useMemo(
    () => data?.sourceData.map(({ name, like_count }) => [name, like_count]),
    [data]
  );

  const sourcesRead = useMemo(
    () => data?.sourceData.map(({ name, read_count }) => [name, read_count]),
    [data]
  );

  const newsCountPerSource = useMemo(
    () => data?.sourceData.map(({ name, news_count }) => [name, news_count]),
    [data]
  );

  const categoriesRead = useMemo(
    () => data?.categoryData.map(({ name, read_count }) => [name, read_count]),
    [data]
  );
  const categoriesLike = useMemo(
    () => data?.categoryData.map(({ name, like_count }) => [name, like_count]),
    [data]
  );
  const newsCountPerCategory = useMemo(
    () => data?.categoryData.map(({ name, news_count }) => [name, news_count]),
    [data]
  );

  if (isLoading)
    return (
      <div style={{ display: "flex", justifyContent: "center" }}>
        <Spinner />
      </div>
    );

  if (!data)
    return (
      <div
        style={{
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          width: "100%",
        }}
      >
        Error while loading
      </div>
    );

  return (
    <Card>
      <CardBody p={["20px", "20px"]}>
        <div style={{ position: "relative" }}>
          <span>Last Update: {lastUpdate}</span>
          <TableChart
            header={["Name", "Count"]}
            data={general ?? []}
            title="General"
            absolute
          />
        </div>
        <div
          style={{ textAlign: "center", fontSize: "3rem", marginTop: "50px" }}
        >
          Sources
        </div>
        <PieChart
          header={["Source Name", "Follow count"]}
          data={sourcesFollow ?? []}
          title="Most Followed Sources"
        />
        <PieChart
          header={["Source Name", "News count"]}
          data={newsCountPerSource ?? []}
          title="Sources with most news(7 days only)"
        />
        <PieChart
          header={["Source Name", "Comment count"]}
          data={sourcesComment ?? []}
          title="Sources with most comment count(7 days only)"
        />
        <PieChart
          header={["Source Name", "Like count"]}
          data={sourcesLike ?? []}
          title="Most Liked Sources(7 days only)"
        />
        <PieChart
          header={["Source Name", "Read count"]}
          data={sourcesRead ?? []}
          title="Most Read Sources(7 days only)"
        />
        <div
          style={{ textAlign: "center", fontSize: "3rem", marginTop: "50px" }}
        >
          Categories
        </div>
        <PieChart
          header={["Category Name", "Read count"]}
          data={categoriesRead ?? []}
          title="Most Read Categories(7 days only)"
        />
        <PieChart
          header={["Category Name", "News count"]}
          data={newsCountPerCategory ?? []}
          title="Categories with most news(7 days only)"
        />
        <PieChart
          header={["Category Name", "Like count"]}
          data={categoriesLike ?? []}
          title="Categories with most likes(7 days only)"
        />
      </CardBody>
    </Card>
  );
};

export default Analytics;
