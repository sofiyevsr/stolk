const nodeExternals = require("webpack-node-externals");
const path = require("path");
const TsconfigPathsPlugin = require("tsconfig-paths-webpack-plugin");
const ForkTsCheckerWebpackPlugin = require("fork-ts-checker-webpack-plugin");

module.exports = {
  mode: "development",
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
  plugins: [
    new ForkTsCheckerWebpackPlugin({
      typescript: {
        diagnosticOptions: {
          semantic: true,
          syntactic: true,
        },
        mode: "write-references",
      },
    }),
  ],
  resolve: {
    extensions: [".ts"],
    plugins: [
      new TsconfigPathsPlugin({
        /* options: see below */
      }),
    ],
  },
  output: {
    path: path.resolve(__dirname, "dist"),
  },
  optimization: {
    nodeEnv: false,
  },
};
