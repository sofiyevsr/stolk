declare namespace Express {
  export interface IAdmin {
    id: number;
    first_name: string;
    last_name: string;
    email: string;
    created_at: string;
  }
  export interface IUser {
    user_id: number;
    first_name: string;
    last_name: string;
    email: string;
    service_type_id: number;
    created_at: string;
    account_type_id: number;
    banned_at: string;
  }
  export interface ISession {
    id: number;
  }
  interface Request {
    session?: IUser & ISession;
    adminSession?: IAdmin;
    realIP: string;
  }
}
