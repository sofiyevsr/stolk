import { FC } from "react";
import {
  StyledWrap,
  StyledTitle,
  StyledSubTitle,
  StyledDesc,
} from "./style";

const ErrorContainer: FC = () => {
  return (
    <StyledWrap>
      <StyledTitle>404 Page Not Found</StyledTitle>
      <StyledSubTitle>
        Oopps. The page you were looking for doesn&apos;t exist.
      </StyledSubTitle>
      <StyledDesc>
        You may have mistyped the address or the page may have moved. Try
        searching below.
      </StyledDesc>
    </StyledWrap>
  );
};

export default ErrorContainer;
