import { ban, unban } from "./ban";
import { users } from "./retrieve";

export default {
  retrieve: {
    users,
  },
  actions: {
    ban,
    unban,
  },
};
