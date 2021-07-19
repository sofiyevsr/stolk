import fs from "fs";
export default async function (path: string) {
  return new Promise<string>((res, rej) => {
    fs.readFile(path, { encoding: "utf8" }, (err, data) => {
      if (err) {
        return rej(err);
      }
      return res(data);
    });
  });
}
