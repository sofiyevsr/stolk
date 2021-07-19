import db from "@db/db";
import { parseRequest } from "@utils/commons/parseReq";
import { tables } from "@utils/constants";
import SoftError from "@utils/softError";
import commentValidation from "@utils/validations/comment";

export const comment = async (newsID: string, userID: number, body: any) => {
  const { user_id, id } = await parseRequest(userID, newsID);
  const { value, error } = commentValidation.validate(body);
  if (error != null) {
    throw new SoftError(error.message);
  }
  const [comment] = await db(tables.news_comment).insert(
    {
      user_id,
      news_id: id,
      comment: value.comment,
    },
    ["id"]
  );
  return comment;
};
