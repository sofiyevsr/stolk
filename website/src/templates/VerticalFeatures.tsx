import { TFunction, useTranslation } from "next-i18next";
import Countdown from "../feature/Countdown";
import { VerticalFeatureRow } from "../feature/VerticalFeatureRow";
import { Section } from "../layout/Section";
import NewspaperIcon from "@heroicons/react/solid/NewspaperIcon";
import PencilIcon from "@heroicons/react/solid/PencilIcon";
import { useInView } from "react-intersection-observer";

const countdowns = (t: TFunction) => [
  {
    Icon: NewspaperIcon,
    from: 0,
    to: 10000,
    duration: 2,
    title: t("home.countdowns.news"),
    color: "bg-red-400",
  },
  {
    Icon: PencilIcon,
    from: 0,
    to: 50,
    duration: 2,
    title: t("home.countdowns.sources"),
    color: "bg-red-400",
  },
];

const VerticalFeatures = () => {
  const { t } = useTranslation();
  const { ref, inView } = useInView({ triggerOnce: true, threshold: 0.2 });

  return (
    <div ref={ref} className="overflow-hidden">
      <div className={`${inView ? "animate-reveal" : "scale-0"}`}>
        <Section>
          <div className="flex flex-col md:justify-between align-center md:flex-row">
            {countdowns(t).map(({ from, title, duration, to, color, Icon }) => (
              <Countdown
                key={title}
                from={from}
                start={inView}
                duration={duration}
                title={title}
                to={to}
                icon={
                  <Icon
                    className={`p-2 text-center text-white rounded-full w-20 h-20 ${color}`}
                  />
                }
              />
            ))}
          </div>
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
      </div>
    </div>
  );
};

export default VerticalFeatures;
