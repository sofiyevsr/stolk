import db from "@config/db/db";
import { tables } from "@utils/constants";
import got from "got";

interface Topics {
  name: string;
  addDate: string;
}

// Gets subscriptions of user from google not managed by server
export async function getAllSubcriptions(token: unknown): Promise<Topics[]> {
  const serverToken = process.env.GCLOUD_FCM_SERVER_KEY;
  if (
    serverToken == null ||
    serverToken === "" ||
    typeof token !== "string" ||
    token.length === 0
  ) {
    throw Error();
  }
  const { data } = await got
    .get(`https://iid.googleapis.com/iid/info/${token}/?details=true`, {
      headers: {
        Authorization: `Bearer ${serverToken}`,
      },
    })
    .json();
  if (
    data["rel"] == null ||
    data["rel"]["topics"] == null ||
    Object.keys(data["rel"]["topics"]).length === 0
  ) {
    return [];
  }
  const topics = data["rel"]["topics"];
  const topicsArr = Object.entries<{ addData: string }>(topics).map(
    ([key, value]) => ({
      name: key,
      addDate: value.addData,
      // ...value,
    })
  );
  return topicsArr;
}

// Gets subscriptions from server
export async function getAllNotificationTypesWithOptouts(userID?: number) {
  let query = db
    .select("t.id", "t.name")
    .from(`${tables.notification_type} as t`);
  if (userID != null) {
    query = query
      .select("o.created_at")
      .leftJoin(`${tables.notification_optout} as o`, function () {
        this.on("t.id", "o.notification_type_id");
        this.andOnVal("o.user_id", "=", userID);
      })
      .groupBy("t.id");
  }
  const result = await query;
  return result;
}
