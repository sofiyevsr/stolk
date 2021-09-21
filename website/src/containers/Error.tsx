import React from "react";
import { Section } from "../layout/Section";
import Error from "@heroicons/react/solid/ExclamationIcon";
import { useTranslation } from "next-i18next";

function ErrorContainer() {
  const { t } = useTranslation();
  return (
    <Section>
      <div className="container flex flex-col items-center p-5 text-center text-white bg-red-500 rounded-lg">
        <Error className="w-28 h-28" />
        <div className="p-5 text-4xl font-bold">
          {t("general.error")}
        </div>
      </div>
    </Section>
  );
}

export default ErrorContainer;
