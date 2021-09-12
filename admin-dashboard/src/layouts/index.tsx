import React from "react";
import Header from "./header";
import Footer from "./footer";

interface IProps {
  hasSidebar?: boolean;
  hideFooter?: boolean;
}

const Layout: React.FC<IProps> = ({ children, hasSidebar, hideFooter }) => {
  return (
    <>
      <Header hasSidebar={hasSidebar} />
      {children}
      {!hideFooter && <Footer />}
    </>
  );
};

Layout.defaultProps = {
  hideFooter: false,
};

export default Layout;
