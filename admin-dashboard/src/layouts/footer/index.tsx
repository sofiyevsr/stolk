import React from "react";
import {
  StyledFooter,
  StyledFooterLeft,
  StyledFooterRight,
} from "./style";

const Footer: React.FC = () => {
  return (
    <StyledFooter>
      <StyledFooterRight></StyledFooterRight>
      <StyledFooterLeft>
        <span>&copy; Stolk {new Date().getFullYear()} </span>
      </StyledFooterLeft>
    </StyledFooter>
  );
};

export default Footer;
