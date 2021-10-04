const path = require("path")
module.exports = {
  i18n: {
    defaultLocale: "az",
    locales: ["az", "en", "ru"],
    localeDetection: false,
    localePath: path.resolve("./public/locales"),
  },
};
