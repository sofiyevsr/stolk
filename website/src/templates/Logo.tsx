import Image from "next/image";
import { AppConfig } from "../utils/AppConfig";

type ILogoProps = {
  xl?: boolean;
};

const Logo = (props: ILogoProps) => {
  const size = props.xl ? "52" : "32";
  const fontStyle = props.xl
    ? "font-semibold text-3xl"
    : "font-semibold text-xl";

  return (
    <span className={`text-gray-900 inline-flex items-end self-end ${fontStyle}`}>
      <Image alt="logo" src={"/assets/vectors/logo.svg"} height={size} width={size} />
      {AppConfig.site_name}
    </span>
  );
};

export { Logo };
