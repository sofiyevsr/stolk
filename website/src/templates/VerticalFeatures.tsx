import { useTranslation } from "next-i18next";
import { VerticalFeatureRow } from "../feature/VerticalFeatureRow";
import { Section } from "../layout/Section";

const VerticalFeatures = () => {
  const { t } = useTranslation();
  return (
    <Section
      title={t("home.features.title")}
      description={t("home.features.description")}
    >
      <VerticalFeatureRow
        title={t("home.features.save_time")}
        description={t("home.features.save_time_description")}
        image="/assets/images/time-save.png"
        imageAlt="Save time"
      />
      <VerticalFeatureRow
        title={t("home.features.frequently_updated")}
        description={t("home.features.frequently_updated_description")}
        image="/assets/images/daily-news.png"
        imageAlt="Updated news"
        reverse
      />
      <VerticalFeatureRow
        title={t("home.features.top_publishers")}
        description={t("home.features.top_publishers_description")}
        image="/assets/images/astronaut.png"
        imageAlt="Astronaut reading news from earth"
      />
    </Section>
  );
};

export { VerticalFeatures };
