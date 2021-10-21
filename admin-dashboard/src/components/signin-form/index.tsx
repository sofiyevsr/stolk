import { FC, useEffect, useRef } from "react";
import { FormGroup, Label, Input, Button } from "../../widgets";
import { useForm } from "react-hook-form";
import { hasKey } from "../../utils/methods";
import { StyledWrap, StyledTitle, StyledDesc, StyledLabelWrap } from "./style";
import AuthApi from "../../utils/api/auth";
import { toast } from "react-toastify";

interface IFormValues {
  email: string;
  password: string;
}

const auth = new AuthApi();
const SigninForm: FC = () => {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm();
  const isRecaptchaLoaded = useRef(false);

  useEffect(() => {
    const script = document.createElement("script");
    script.src =
      "https://www.google.com/recaptcha/api.js?render=6LfdpfobAAAAAIMpajlitheNwdUx8jU14cWlaTv1";
    script.addEventListener("load", () => {
      (window as any).grecaptcha?.ready(() => {
        isRecaptchaLoaded.current = true;
      });
    });
    document.body.append(script);
    return () => {
      script.remove();
    };
  }, []);

  const onSubmit = async (data: IFormValues) => {
    if (
      isRecaptchaLoaded.current === false ||
      (window as any).grecaptcha == null
    ) {
      toast("Recaptcha hasn't loaded yet", { type: "error" });
      return;
    }
    return (window as any).grecaptcha
      .execute("6LfdpfobAAAAAIMpajlitheNwdUx8jU14cWlaTv1", { action: "login" })
      .then((token: string) => {
        auth
          .login(data.email, data.password, token)
          .then((_) => {})
          .catch((_) => {});
      });
  };
  return (
    <StyledWrap>
      <StyledTitle>Sign In</StyledTitle>
      <StyledDesc>Welcome back! Please signin to continue.</StyledDesc>
      <form onSubmit={handleSubmit(onSubmit)} noValidate>
        <FormGroup mb="20px">
          <Label display="block" mb="5px" htmlFor="email">
            Email address
          </Label>
          <Input
            type="email"
            id="email"
            placeholder="yourname@yourmail.com"
            feedbackText={errors?.email?.message}
            state={hasKey(errors, "email") ? "error" : "success"}
            showState={!!hasKey(errors, "email")}
            {...register("email", {
              required: "Email is required",
              pattern: {
                value: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i,
                message: "invalid email address",
              },
            })}
          />
        </FormGroup>
        <FormGroup mb="20px">
          <StyledLabelWrap>
            <Label display="block" mb="5px" htmlFor="password">
              Password
            </Label>
          </StyledLabelWrap>
          <Input
            id="password"
            type="password"
            placeholder="Enter your password"
            feedbackText={errors?.password?.message}
            state={hasKey(errors, "password") ? "error" : "success"}
            showState={!!hasKey(errors, "password")}
            {...register("password", {
              required: "Password is required",
              minLength: {
                value: 8,
                message: "Minimum length is 6",
              },
            })}
          />
        </FormGroup>
        <Button type="submit" color="brand2" fullwidth disabled={isSubmitting}>
          Sign In
        </Button>
      </form>
    </StyledWrap>
  );
};

export default SigninForm;
