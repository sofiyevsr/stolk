import { ban, unban } from "./ban";
import { users } from "./retrieve";

export default {
  retrieve: {
    all: users,
  },
  actions: {
    ban,
    unban,
  },
};
