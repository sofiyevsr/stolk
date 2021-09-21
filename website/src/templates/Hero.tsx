import { useTranslation } from "next-i18next";
import Image from "next/image";
import { useInView } from "react-intersection-observer";
import { Background } from "../background/Background";
import { Button } from "../button/Button";
import { HeroOneButton } from "../hero/HeroOneButton";
import { Section } from "../layout/Section";

const Hero = () => {
  const { t } = useTranslation();
  const { ref, inView } = useInView({ triggerOnce: true });
  return (
    <div ref={ref} className="overflow-hidden">
      <Background color="bg-gray-100">
        <Section>
          <div className={`flex items-center justify-center p-12`}>
            <div
              className={inView ? "animate-reveal-left" : "-translate-x-full"}
            >
              <HeroOneButton
                title={
                  <>
                    {t("home.cta-title") + "\n"}
                    <span className="text-primary-500">
                      {t("home.cta-subtitle")}
                    </span>
                  </>
                }
                description={t("home.cta-description")}
                button={
                  <Button
                    onClick={() => {
                      if (window != null) {
                        const appLinks =
                          window.document.getElementById("app-links");
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
            </div>
            <div
              className={`hidden md:m-5 md:block ${
                inView ? "animate-reveal-right" : "translate-x-full"
              }`}
            >
              <Image
                src={"/assets/images/website-header.png"}
                alt="website-header"
                width={400}
                height={400}
              />
            </div>
          </div>
        </Section>
      </Background>
    </div>
  );
};
export { Hero };
