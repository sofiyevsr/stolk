import { FC } from "react";
import loginImage from "../../utils/images/login.png";
import SigninForm from "../../components/signin-form";
import {
  StyledMedia,
  StyledMediaBody,
  StyledImage,
  StyledSignin,
} from "./style";

const AuthContainer: FC = () => {
  return (
    <StyledMedia>
      <StyledMediaBody>
        <StyledImage>
          <img src={loginImage} width={400} alt="Login" />
        </StyledImage>
      </StyledMediaBody>
      <StyledSignin>
        <SigninForm />
      </StyledSignin>
    </StyledMedia>
  );
};

export default AuthContainer;
