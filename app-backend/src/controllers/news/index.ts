import { bookmark, unbookmark } from "./bookmark";
import { like, unlike } from "./like";
import retrieve from "./retrieve";
import { comment } from "./comment";
import { read } from "./read";

export default {
  actions: {
    like,
    unlike,
    bookmark,
    unbookmark,
    comment,
    read,
  },
  retrieve,
};
