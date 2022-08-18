const webpack = require("webpack");
const webpackConfig = require("./webpack.development.config.js");
const { spawn } = require("child_process");

const compiler = webpack(webpackConfig);
let child;

compiler.watch({}, (error) => {
  if (error) console.log(error);
});

compiler.hooks.afterCompile.tap("Api Runner", () => {
  if (child) child.kill("SIGKILL");
  child = spawn("node", ["dev_artifacts/main.js"]);
  child.stdout.pipe(process.stdout);
  child.stderr.pipe(process.stderr);
});
