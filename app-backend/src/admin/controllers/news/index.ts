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
} from "./actions";
import retrieve from "./retrieve";

export default {
  retrieve,
  actions: {
    news: {
      hide: hideNews,
      unhide: unhideNews,
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
