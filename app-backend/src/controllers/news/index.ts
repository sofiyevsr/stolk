import { bookmark, unbookmark } from "./bookmark";
import { like, unlike } from "./like";
import retrieve from "./retrieve";
import { comment } from "./comment";

export default {
  actions: {
    like,
    unlike,
    bookmark,
    unbookmark,
    comment,
  },
  retrieve,
};
