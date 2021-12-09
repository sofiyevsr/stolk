const path = require("path")
module.exports = {
  i18n: {
    defaultLocale: "az",
    locales: ["az", "en", "ru"],
    localePath: path.resolve("./public/locales"),
  },
};
