import { follow, unfollow } from "./follow";
import { allSources } from "./retrieve";

export default {
  actions: {
    follow,
    unfollow,
  },
  retrieve: {
    allSources,
  },
};
