import { useTranslation } from "next-i18next";
import Link from "next/link";

import { Background } from "../background/Background";
import { Button } from "../button/Button";
import { HeroOneButton } from "../hero/HeroOneButton";
import { Section } from "../layout/Section";
import { NavbarTwoColumns } from "../navigation/NavbarTwoColumns";
import { Logo } from "./Logo";

const Hero = () => {
  const { t } = useTranslation();
  return (
    <Background color="bg-gray-100">
      <Section yPadding="py-6">
        <NavbarTwoColumns logo={<Logo xl />}>
          <li>
            <Link href="/">
              <a>Sign in</a>
            </Link>
          </li>
        </NavbarTwoColumns>
      </Section>

      <Section yPadding="pt-20 pb-32">
        <HeroOneButton
          title={
            <>
              {t("title") + "\n"}
              <span className="text-primary-500">{t("for-who")}</span>
            </>
          }
          description="The easiest way to build a React landing page in seconds."
          button={
            <Link href="https://creativedesignsguru.com/category/nextjs/">
              <a>
                <Button xl>Download Your Free Theme</Button>
              </a>
            </Link>
          }
        />
      </Section>
    </Background>
  );
};
export { Hero };
