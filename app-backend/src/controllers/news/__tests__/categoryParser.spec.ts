import { MAX_CATEGORIES_COUNT } from "@utils/constants";
import parseCats from "../helpers/categoryParser";

describe("parser behaviour", () => {
  test("should return null on null or undefined", () => {
    const res = parseCats(undefined);
    expect(res).toEqual(null);
  });
  test("should return null if input doesn't have cat", () => {
    const res = parseCats("[as],string,{test:'test'}");
    expect(res).toEqual(null);
  });
  test("should return null if input is not 'splittable'", () => {
    const res = parseCats("alkjfa.-_.123");
    expect(res).toEqual(null);
  });
  test("success case should return filtered cats when any is not number", () => {
    const res = parseCats("1,string,2");
    expect(res).toEqual([1, 2]);
  });
  test("should filter out numbers higher than max category limit ", () => {
    const res = parseCats(
      `${MAX_CATEGORIES_COUNT + 1},1,${MAX_CATEGORIES_COUNT + 1},3`
    );
    expect(res).toEqual([1, 3]);
  });
  test("normal success case", () => {
    const res = parseCats("1,2,3");
    expect(res).toEqual([1, 2, 3]);
  });
});
