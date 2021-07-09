// @ts-ignore
const illegalRe = /[/?<>\\:*|"'`]/g;

export default (s: string) => {
  return s.replace(illegalRe, "");
};
