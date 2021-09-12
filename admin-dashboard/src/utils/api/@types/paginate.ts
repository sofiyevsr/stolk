export interface IPaginate {
  lastID: number;
}

export interface TableInterface {
  getAll(data: IPaginate): Promise<any>;
}
