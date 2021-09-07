import React, { Suspense, lazy } from "react";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";
import Preloader from "./components/preloader";

const Dashboard = lazy(() => import("./pages/dashboard"));
const SignIn = lazy(() => import("./pages/signin"));
const SignUp = lazy(() => import("./pages/signup"));
const VerifyAccount = lazy(() => import("./pages/verify-account"));
const ForgotPassword = lazy(() => import("./pages/forgot-password"));
const ErrorNotFound = lazy(() => import("./pages/error-404"));
const Error500 = lazy(() => import("./pages/error-500"));
const Error503 = lazy(() => import("./pages/error-503"));
const Error505 = lazy(() => import("./pages/error-505"));
const ProfileView = lazy(() => import("./pages/profile-view"));
const Connections = lazy(() => import("./pages/connections"));
const Groups = lazy(() => import("./pages/groups"));
const Events = lazy(() => import("./pages/events"));
const Timeline = lazy(() => import("./pages/timeline"));
const Pricing = lazy(() => import("./pages/pricing"));
const HelpCenter = lazy(() => import("./pages/help-center"));
const Invoice = lazy(() => import("./pages/invoice"));

const App: React.FC = () => {
  return (
    <>
      <Router>
        <Suspense fallback={<Preloader />}>
          <Switch>
            <Route exact path="/" component={Dashboard} />
            <Route exact path="/signin" component={SignIn} />
            <Route exact path="/signup" component={SignUp} />
            <Route exact path="/verify-account" component={VerifyAccount} />
            <Route exact path="/forgot-password" component={ForgotPassword} />
            <Route exact path="/error-500" component={Error500} />
            <Route exact path="/error-503" component={Error503} />
            <Route exact path="/error-505" component={Error505} />
            <Route exact path="/profile-view" component={ProfileView} />
            <Route exact path="/connections" component={Connections} />
            <Route exact path="/groups" component={Groups} />
            <Route exact path="/events" component={Events} />
            <Route exact path="/timeline" component={Timeline} />
            <Route exact path="/pricing" component={Pricing} />
            <Route exact path="/help-center" component={HelpCenter} />
            <Route exact path="/invoice" component={Invoice} />
            <Route path="*" component={ErrorNotFound} />
          </Switch>
        </Suspense>
      </Router>

      {/* <SettingsCard /> */}
    </>
  );
};

export default App;
