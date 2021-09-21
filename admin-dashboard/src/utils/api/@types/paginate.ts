export interface IPaginate {
  lastID: number | null;
}

export interface TableInterface {
  getAll(data: IPaginate): Promise<any>;
}
