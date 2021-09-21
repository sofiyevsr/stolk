import React from "react";
import ResetForm from "./ResetForm";
import ErrorContainer from "../containers/Error";

interface Props {
  checkOkay: boolean;
}

function ResetLayout({ checkOkay }: Props) {
  return <>{checkOkay === true ? <ResetForm /> : <ErrorContainer />}</>;
}

export default ResetLayout;
