import React, { Suspense, lazy } from "react";
import { useSelector } from "react-redux";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";
import Preloader from "./components/preloader";
import { RootState } from "./redux/store";
import { ToastContainer } from "react-toastify";
import "./App.scss";
import "react-toastify/dist/ReactToastify.css";

const Dashboard = lazy(() => import("./pages/dashboard"));
const NewsPage = lazy(() => import("./pages/news"));
const Sources = lazy(() => import("./pages/sources"));
const Notification = lazy(() => import("./pages/notification"));
const Reports = lazy(() => import("./pages/reports"));
const Users = lazy(() => import("./pages/users"));
const SignIn = lazy(() => import("./pages/signin"));
const SignUp = lazy(() => import("./pages/signup"));
const VerifyAccount = lazy(() => import("./pages/verify-account"));
const ForgotPassword = lazy(() => import("./pages/forgot-password"));
const ErrorNotFound = lazy(() => import("./pages/error-404"));
const Error500 = lazy(() => import("./pages/error-500"));
const Error503 = lazy(() => import("./pages/error-503"));
const Error505 = lazy(() => import("./pages/error-505"));
const ProfileView = lazy(() => import("./pages/profile-view"));

const App: React.FC = () => {
  const isAuthorized = useSelector<RootState>(
    (state) => state.user.isAuthorized
  );
  return (
    <>
      {/* {isAuthorized == null ? ( */}
      {false ? (
        <Preloader />
      ) : (
        <Router>
          <Suspense fallback={<Preloader />}>
            <Switch>
              <Route exact path="/" component={Dashboard} />
              <Route exact path="/news" component={NewsPage} />
              <Route exact path="/users" component={Users} />
              <Route exact path="/sources" component={Sources} />
              <Route exact path="/reports" component={Reports} />
              <Route exact path="/notification" component={Notification} />
              <Route exact path="/signin" component={SignIn} />
              <Route exact path="/signup" component={SignUp} />
              <Route exact path="/verify-account" component={VerifyAccount} />
              <Route exact path="/forgot-password" component={ForgotPassword} />
              <Route exact path="/error-500" component={Error500} />
              <Route exact path="/error-503" component={Error503} />
              <Route exact path="/error-505" component={Error505} />
              <Route exact path="/profile-view" component={ProfileView} />
              <Route component={ErrorNotFound} />
            </Switch>
          </Suspense>
        </Router>
      )}
      <ToastContainer />
    </>
  );
};

export default App;
