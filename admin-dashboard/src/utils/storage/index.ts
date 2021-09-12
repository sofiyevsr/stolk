class StorageService {
  private localStorage: Storage;

  constructor() {
    this.localStorage = window.localStorage;
  }

  public login(token: string): void {
    this.localStorage.setItem("token", token);
  }

  public logout(): void {
    this.localStorage.removeItem("token");
  }

  public getToken(): string | null {
    return this.localStorage.getItem("token");
  }
}

export default StorageService;
