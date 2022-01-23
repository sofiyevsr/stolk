import {
  deleteCategory,
  deleteComment,
  hideCategory,
  hideNews,
  insertCategory,
  linkCategory,
  unhideCategory,
  unhideNews,
  updateCategory,
  deleteNews,
} from "./actions";
import retrieve from "./retrieve";

export default {
  retrieve,
  actions: {
    news: {
      hide: hideNews,
      unhide: unhideNews,
      deleteNews,
    },
    category: {
      insert: insertCategory,
      delete: deleteCategory,
      update: updateCategory,
      hide: hideCategory,
      unhide: unhideCategory,
    },
    categoryAlias: {
      link: linkCategory,
    },
    comment: {
      delete: deleteComment,
    },
  },
};
