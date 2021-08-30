import React, { ReactNode } from "react";

interface Props {
  children: ReactNode;
}

function Title({ children }: Props) {
  return <div className="font-bold">{children}</div>;
}

export default Title;
