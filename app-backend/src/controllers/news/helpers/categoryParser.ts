import { MAX_CATEGORIES_COUNT } from "@utils/constants";

const parseCats = (cats?: string) => {
  if (cats == null) {
    return null;
  }
  const catsArr = cats.split(",");
  const parsedCats = catsArr.reduce((acc, cat) => {
    const parsedCat = Number.parseInt(cat, 10);
    if (Number.isNaN(parsedCat) === false && parsedCat < MAX_CATEGORIES_COUNT) {
      acc.push(parsedCat);
    }
    return acc;
  }, [] as number[]);
  return parsedCats.length === 0 ? null : parsedCats;
};
export default parseCats;
