import ReactDOM from "react-dom";
import { Provider } from "react-redux";
import ThemeProvider from "./theme-provider";
import { store } from "./redux/store";
import App from "./App";
import ErrorBoundary from "./containers/error/ErrorBoundary";

ReactDOM.render(
  <ErrorBoundary>
    <Provider store={store}>
      <ThemeProvider>
        <App />
      </ThemeProvider>
    </Provider>
  </ErrorBoundary>,
  document.getElementById("root")
);
