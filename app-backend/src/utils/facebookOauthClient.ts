import got from "got";

interface UserData {
  first_name: string;
  last_name: string;
  email: string | null;
  id: string;
}

interface VerifyResponse {
  data: {
    app_id: string;
    type: string;
    application: string;
    data_access_expires_at: number;
    expires_at: number;
    is_valid: boolean;
    issued_at: number;
    metadata: {
      auth_type: string;
      sso: string;
    };
    scopes: string[];
    user_id: string;
  };
}

class FacebookOauthClient {
  private fields = ["first_name", "last_name", "email", "id"];
  public async verifyToken(token: string) {
    const appID = process.env.FACEBOOK_APP_ID;
    const appSecret = process.env.FACEBOOK_APP_SECRET;
    if (appID == null || appSecret == null)
      throw Error("invalid facebook credentials");
    const { body } = await got.get(
      `https://graph.facebook.com/debug_token?input_token=${token}&access_token=${appID}|${appSecret}`,
      { responseType: "json" }
    );
    return body as VerifyResponse;
  }

  public async getUserData(token: string) {
    const { body } = await got.get(
      `https://graph.facebook.com/me?access_token=${token}&fields=${this.fields.join(
        ","
      )}`,
      { responseType: "json" }
    );
    return body as UserData;
  }
}
export default FacebookOauthClient;
