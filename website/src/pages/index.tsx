import { Base } from "../templates/Base";
import { serverSideTranslations } from "next-i18next/serverSideTranslations";

const Index = () => <Base />;

export async function getStaticProps({ locale }: { locale: string }) {
  return {
    props: {
      ...(await serverSideTranslations(locale)),
    },
  };
}

export default Index;
