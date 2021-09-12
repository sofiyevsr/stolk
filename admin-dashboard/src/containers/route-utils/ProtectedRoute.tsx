import { useSelector } from "react-redux";
import { Redirect, Route, RouteProps } from "react-router-dom";
import { RootState } from "../../redux/store";

function ForwardRoute(props: RouteProps) {
  const isAuthorized = useSelector<RootState>(
    (state) => state.user.isAuthorized
  );
  return isAuthorized === false ? <Redirect to="/signin" /> : <Route {...props} />;
}

export default ForwardRoute;
