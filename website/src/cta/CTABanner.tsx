import { ReactNode } from "react";
import Image from "next/image";
import playStore from "../../public/assets/play-store.png";
import appStore from "../../public/assets/app-store.png";

type ICTABannerProps = {
  title: string;
  subtitle: string;
  button: ReactNode;
};

const CTABanner = (props: ICTABannerProps) => (
  <div className="text-center flex flex-col p-4 sm:text-left sm:flex-row sm:items-center sm:justify-between sm:p-12 bg-primary-100 rounded-md">
    <div className="text-2xl font-semibold">
      <div className="text-gray-900">{props.title}</div>
      <div className="text-primary-500">{props.subtitle}</div>
    </div>

    <div className="whitespace-no-wrap mt-3 flex justify-center sm:mt-0 sm:ml-2">
      <a target="_blank" href="https://apple.com">
        <Image src={appStore} />
      </a>
      <a target="_blank" href="https://google.com">
        <Image src={playStore} />
      </a>
    </div>
  </div>
);

export { CTABanner };
