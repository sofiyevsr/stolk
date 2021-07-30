import db from "@db/db";
import { tables } from "@utils/constants";
import SoftError from "@utils/softError";
import commentValidation from "@utils/validations/comment";

export const comment = async (newsID: string, userID: number, body: any) => {
  const { value, error } = commentValidation.validate(body);
  if (error != null) {
    throw new SoftError(error.message);
  }
  const [comment] = await db(tables.news_comment).insert(
    {
      user_id: userID,
      news_id: newsID,
      comment: value.comment,
    },
    ["id", "user_id", "comment", "created_at"]
  );
  return comment;
};
