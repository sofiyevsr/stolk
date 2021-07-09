import { bookmark, unbookmark } from "./bookmark";
import { like, unlike } from "./like";
import retrieve from "./retrieve";

export default {
  actions: {
    like,
    unlike,
    bookmark,
    unbookmark,
  },
  retrieve,
};
