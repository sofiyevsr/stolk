import React from "react";
import ErrorContainer from "../containers/Error";
import SuccessContainer from "../containers/Success";

interface Props {
  checkOkay: boolean;
}

function ConfirmLayout({ checkOkay }: Props) {
  return <>{checkOkay === true ? <SuccessContainer /> : <ErrorContainer />}</>;
}

export default ConfirmLayout;
