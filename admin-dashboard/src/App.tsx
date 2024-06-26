import React, { Suspense, lazy, useEffect } from "react";
import { useSelector } from "react-redux";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";
import Preloader from "./components/preloader";
import { RootState } from "./redux/store";
import { ToastContainer } from "react-toastify";
import ForwardRoute from "./containers/route-utils/ForwardRoute";
import ProtectedRoute from "./containers/route-utils/ProtectedRoute";
import AuthApi from "./utils/api/auth";
import { useAppDispatch } from "./redux/hooks";
import { logout } from "./redux/slices/user";
import "react-toastify/dist/ReactToastify.css";

const Dashboard = lazy(() => import("./pages/dashboard"));
const NewsPage = lazy(() => import("./pages/news"));
const Sources = lazy(() => import("./pages/sources"));
const Notification = lazy(() => import("./pages/notification"));
const NewsReports = lazy(() => import("./pages/news-reports"));
const CommentReports = lazy(() => import("./pages/comment-reports"));
const Comments = lazy(() => import("./pages/comments"));
const Users = lazy(() => import("./pages/users"));
const Categories = lazy(() => import("./pages/categories"));
const CategoryAliases = lazy(() => import("./pages/category-aliases"));
const SignIn = lazy(() => import("./pages/signin"));
const ErrorNotFound = lazy(() => import("./pages/error-404"));

const authService = new AuthApi();
const App: React.FC = () => {
  const isAuthorized = useSelector<RootState>(
    (state) => state.user.isAuthorized
  );
  const dispatch = useAppDispatch();

  useEffect(() => {
    (async () => {
      try {
        await authService.checkToken();
      } catch (error) {
        dispatch(logout());
      }
    })();
  }, [dispatch]);

  return (
    <>
      {isAuthorized == null ? (
        <Preloader />
      ) : (
        <Router>
          <Suspense fallback={<Preloader />}>
            <Switch>
              <ProtectedRoute exact path="/" component={Dashboard} />
              <ProtectedRoute exact path="/news" component={NewsPage} />
              <ProtectedRoute exact path="/users" component={Users} />
              <ProtectedRoute exact path="/sources" component={Sources} />
              <ProtectedRoute exact path="/categories" component={Categories} />
              <ProtectedRoute
                exact
                path="/category-aliases"
                component={CategoryAliases}
              />
              <ProtectedRoute exact path="/comments" component={Comments} />
              <ProtectedRoute
                exact
                path="/news-reports"
                component={NewsReports}
              />
              <ProtectedRoute
                exact
                path="/comment-reports"
                component={CommentReports}
              />
              <ProtectedRoute
                exact
                path="/notification"
                component={Notification}
              />
              <ForwardRoute exact path="/signin" component={SignIn} />
              <Route component={ErrorNotFound} />
            </Switch>
          </Suspense>
        </Router>
      )}
      <ToastContainer position={"bottom-center"} />
    </>
  );
};

export default App;
