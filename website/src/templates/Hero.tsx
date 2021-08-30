import { useTranslation } from "next-i18next";
import { Background } from "../background/Background";
import { Button } from "../button/Button";
import { HeroOneButton } from "../hero/HeroOneButton";
import { Section } from "../layout/Section";

const Hero = () => {
  const { t } = useTranslation();
  return (
    <Background color="bg-gray-100">
      <Section yPadding="pt-20 pb-32">
        <HeroOneButton
          title={
            <>
              {t("home.cta-title") + "\n"}
              <span className="text-primary-500">{t("home.cta-subtitle")}</span>
            </>
          }
          description={t("home.cta-description")}
          button={
            <Button
              onClick={() => {
                if (window != null) {
                  const appLinks = window.document.getElementById("app-links");
                  if (appLinks)
                    window.scrollTo({
                      top: appLinks.offsetTop,
                      behavior: "smooth",
                    });
                }
              }}
              xl
            >
              {t("home.cta-button")}
            </Button>
          }
        />
      </Section>
    </Background>
  );
};
export { Hero };
