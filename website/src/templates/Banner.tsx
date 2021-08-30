import { useTranslation } from "next-i18next";
import { CTABanner } from "../cta/CTABanner";
import { Section } from "../layout/Section";

const Banner = () => {
  const { t } = useTranslation();
  return (
    <Section id="app-links">
      <CTABanner title={t("home.use_now")} subtitle={t("home.use_now_free")} />
    </Section>
  );
};

export { Banner };
