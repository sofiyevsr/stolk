import { FC } from "react";
import { ThemeProvider, themes } from "./utils/styled";
import { GlobalStyle } from "./utils/css";
import { TTheme } from "./utils/types";
import { useAppDispatch, useAppSelector } from "./redux/hooks";
import { toggleTheme } from "./redux/slices/ui";

const Theme: FC = ({ children }) => {
  const dispatch = useAppDispatch();
  const { theme } = useAppSelector((state) => state.ui);

  const themeHandler = (curTheme: TTheme) => {
    dispatch(toggleTheme({ theme: curTheme }));
  };
  return (
    <ThemeProvider theme={themes[theme]}>
      <GlobalStyle />
      {children}
    </ThemeProvider>
  );
};

export default Theme;
