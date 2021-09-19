import React from "react";
import { Section } from "../layout/Section";
import Success from "@heroicons/react/solid/CheckCircleIcon";
import { useTranslation } from "next-i18next";

function SuccessContainer() {
  const { t } = useTranslation();
  return (
    <Section>
      <div className="container flex flex-col items-center p-5 text-center text-white bg-green-500 rounded-lg">
        <Success className="w-28 h-28" />
        <div className="p-5 text-4xl font-bold">
          {t("general.success")}
        </div>
      </div>
    </Section>
  );
}

export default SuccessContainer;
