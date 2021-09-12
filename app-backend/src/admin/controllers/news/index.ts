import {
  deleteCategory,
  deleteComment,
  hideNews,
  insertCategory,
  linkCategory,
  unhideNews,
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
    },
    categoryAlias: {
      link: linkCategory,
    },
    comment: {
      delete: deleteComment,
    },
  },
};
