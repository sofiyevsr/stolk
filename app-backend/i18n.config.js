module.exports = {
  output: "src/config/i18n/$LOCALE/$NAMESPACE.json",
  ts: [
    {
      lexer: "JavascriptLexer",
      functions: ["i18next.t", "i18next", "t"], // Array of functions to match
    },
  ],
  locales: ["translation"],
  verbose: true,
};
