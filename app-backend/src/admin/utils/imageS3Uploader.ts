import {
  PutObjectCommandInput,
  PutObjectCommand,
  DeleteObjectCommandInput,
  DeleteObjectCommand,
} from "@aws-sdk/client-s3";
import i18next from "@translate/i18next";
import S3 from "@utils/s3-sdk";
import SoftError from "@utils/softError";
import multer from "multer";

const fileParser = multer({
  limits: { fileSize: 5e6 },
  fileFilter: (_, file, cb) => {
    // Accept max 5mb
    if (file.mimetype === "image/jpeg") {
      return cb(null, true);
    }
    return cb(new SoftError(i18next.t("errors.wrong_type")));
  },
});

const save = (
  key: string,
  bucket: string,
  file: Express.Multer.File | undefined
) => {
  if (file == null) throw new SoftError(i18next.t("errors.empty_image"));
  const input: PutObjectCommandInput = {
    Key: key,
    Bucket: bucket,
    Body: file.buffer,
  };
  const cmd = new PutObjectCommand(input);
  return S3.send(cmd);
};

const del = (key: string, bucket: string) => {
  const input: DeleteObjectCommandInput = {
    Key: key,
    Bucket: bucket,
  };
  const cmd = new DeleteObjectCommand(input);
  return S3.send(cmd);
};

export default {
  fileParser,
  save,
  del,
};
