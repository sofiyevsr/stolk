import Image from "next/image";
import playStore from "../../public/assets/images/play-store.png";

type ICTABannerProps = {
  title: string;
  subtitle: string;
};

const CTABanner = (props: ICTABannerProps) => (
  <div className="flex flex-col p-4 text-center sm:text-left sm:flex-row sm:items-center sm:justify-between sm:p-12 bg-primary-100 rounded-md">
    <div className="text-3xl font-semibold">
      <div className="text-gray-900">{props.title}</div>
      <div className="text-primary-500">{props.subtitle}</div>
    </div>

    <div className="flex flex-col justify-center mt-3 whitespace-no-wrap sm:mt-0 sm:ml-2">
      {/* TODO Enable after app store */}
      {/* <a target="_blank" href="https://apple.com"> */}
      {/*   <Image alt="app-store" src={appStore} /> */}
      {/* </a> */}
      <a
        target="_blank"
        href="https://play.google.com/store/apps/details?id=app.stolk.android"
      >
        <Image alt="play-store" src={playStore} />
      </a>
    </div>
  </div>
);

export { CTABanner };
