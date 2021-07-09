import { S3Client } from "@aws-sdk/client-s3";

const s3Instance = new S3Client({
  region: "eu-central-1",
  credentials: {
    accessKeyId: process.env.ACCESSKEYID as string,
    secretAccessKey: process.env.SECRETACCESSKEY as string,
  },
});

export default s3Instance;
