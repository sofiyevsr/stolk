import Link from "next/link";
import React from "react";
import LanguageSelector from "../inputs/LanguageSelector";
import { Section } from "../layout/Section";
import { Logo } from "../templates/Logo";

const Navbar = () => (
  <Section yPadding="py-3">
    <div className="flex flex-wrap justify-between items-center">
      <Link href="/">
        <a>
          <Logo xl />
        </a>
      </Link>

      <nav>
        <ul className="navbar flex items-center font-medium text-xl text-gray-800">
          <LanguageSelector />
        </ul>
      </nav>

      <style jsx>
        {`
          .navbar :global(li:not(:first-child)) {
            @apply mt-0;
          }

          .navbar :global(li:not(:last-child)) {
            @apply mr-5;
          }
        `}
      </style>
    </div>
  </Section>
);

export default Navbar;
