import db from "@db/db";
import { tables } from "@utils/constants";
import SoftError from "@utils/softError";
import report from "@utils/validations/report";

const news = async (news_id: number, user_id: number, body: any) => {
  const { value, error } = report.news.validate(body);
  if (error != null) {
    throw new SoftError(error.message);
  }
  const trx = await db.transaction();

  try {
    const [report] = await trx(tables.report).insert(
      {
        message: value.message,
      },
      ["id"]
    );
    await trx(tables.news_report).insert({
      report_id: report.id,
      news_id,
      user_id,
    });
    await trx.commit();
  } catch (error) {
    await trx.rollback();
    throw error;
  }
};

const comment = async (comment_id: number, user_id: number, body: any) => {
  const { value, error } = report.comment.validate(body);
  if (error != null) {
    throw new SoftError(error.message);
  }
  const trx = await db.transaction();

  try {
    const [report] = await trx(tables.report).insert(
      {
        message: value.message,
      },
      ["id"]
    );
    await trx(tables.comment_report).insert({
      report_id: report.id,
      comment_id,
      user_id,
    });
    await trx.commit();
  } catch (error) {
    await trx.rollback();
    throw error;
  }
};

export default { news, comment };
