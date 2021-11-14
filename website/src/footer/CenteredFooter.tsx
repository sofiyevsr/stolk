import { ReactNode } from "react";

import { FooterIconList } from "./FooterIconList";

type ICenteredFooterProps = {
  logo?: ReactNode;
  iconList?: ReactNode;
  children: ReactNode;
};

const CenteredFooter = (props: ICenteredFooterProps) => (
  <div className="text-center">
    {props.logo}

    <nav>
      <ul className="flex flex-row justify-center mt-5 text-xl font-medium text-gray-800 navbar">
        {props.children}
      </ul>
    </nav>

    {props.iconList != null && (
      <div className="flex justify-center mt-8">
        <FooterIconList>{props.iconList}</FooterIconList>
      </div>
    )}
    <style jsx>
      {`
        .navbar :global(li) {
          @apply mx-4;
        }
      `}
    </style>
  </div>
);

export { CenteredFooter };
