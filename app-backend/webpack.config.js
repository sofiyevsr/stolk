const nodeExternals = require("webpack-node-externals");
const path = require("path");
const TsconfigPathsPlugin = require("tsconfig-paths-webpack-plugin");

module.exports = {
  mode: "production",
  target: "node",
  externals: [nodeExternals()],
  entry: "./index.ts",
  module: {
    rules: [
      {
        test: /\.ts$/,
        use: "babel-loader",
        exclude: /node_modules/,
      },
      {
        test: /\.html$/,
        type: "asset/source",
      },
    ],
  },
  resolve: {
    extensions: [".ts"],
    plugins: [new TsconfigPathsPlugin()],
  },
  output: {
    path: path.resolve(__dirname, "dist"),
  },
  optimization: {
    nodeEnv: false,
  },
};
