import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { v4 } from "uuid";
import { IJWTUser } from "./constants";

export async function hashPassword(s: string, saltRounds = 10) {
  const salt = await bcrypt.genSalt(saltRounds);
  const hash = await bcrypt.hash(s, salt);
  return hash;
}

export function comparePassword(plain: string, hash: string) {
  if (plain === "" || hash === "") {
    return false;
  }
  return bcrypt.compare(plain, hash);
}

export async function generateAccessToken(user: IJWTUser) {
  return new Promise<string | undefined>((res, rej) => {
    jwt.sign(
      { id: user.id },
      process.env.A_JWT_KEY as string,
      (err: Error | null, token: string | undefined) => {
        if (err) {
          return rej(err);
        }
        if (token == null) {
          return rej();
        }
        return res(token);
      }
    );
  });
}

export async function verifyToken(token: string) {
  return new Promise<{ id: string; audience: string }>((res, rej) =>
    jwt.verify(token, process.env.A_JWT_KEY as string, {}, (err, decoded) => {
      if (err) {
        return rej(err);
      }
      if (decoded == null) {
        return rej(Error());
      }
      return res(decoded as any);
    })
  );
}

export async function generateResetToken() {
  const token = v4();
  const hash = await hashPassword(token);
  return { hash, plain: token };
}

export async function generateConfirmationToken() {
  const token = v4();
  const hash = await hashPassword(token);
  return { hash, plain: token };
}

export async function hashResetToken(token: string) {
  return hashPassword(token);
}
