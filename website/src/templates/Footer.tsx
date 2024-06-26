import { useTranslation } from "next-i18next";
import Link from "next/link";
import { Background } from "../background/Background";
import { CenteredFooter } from "../footer/CenteredFooter";
import { Section } from "../layout/Section";
import { Logo } from "./Logo";

const Footer = () => {
  const { t } = useTranslation();
  return (
    <Background color="bg-gray-100">
      <Section yPadding={"py-4"}>
        <CenteredFooter logo={<Logo />}>
          <li>
            <Link href="/privacy-policy">
              <a>Privacy Policy</a>
            </Link>
          </li>
          <li>
            <Link href="/terms-of-use">
              <a>Terms of use</a>
            </Link>
          </li>
        </CenteredFooter>
        <CenteredFooter
          logo={
            <div style={{ fontWeight: "bold", fontSize: 24, marginTop: 10 }}>
              {t("footer.have_question")}
            </div>
          }
          iconList={
            <>
              {/* TODO Enable after facebook */}
              {/* <Link href="/"> */}
              {/*   <a> */}
              {/*     <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"> */}
              {/*       <path d="M23.998 12c0-6.628-5.372-12-11.999-12C5.372 0 0 5.372 0 12c0 5.988 4.388 10.952 10.124 11.852v-8.384H7.078v-3.469h3.046V9.356c0-3.008 1.792-4.669 4.532-4.669 1.313 0 2.686.234 2.686.234v2.953H15.83c-1.49 0-1.955.925-1.955 1.874V12h3.328l-.532 3.469h-2.796v8.384c5.736-.9 10.124-5.864 10.124-11.853z" /> */}
              {/*     </svg> */}
              {/*   </a> */}
              {/* </Link> */}
            </>
          }
        >
          <div style={{ display: "flex", flexDirection: "column" }}>
            <a
              style={{ textDecoration: "underline" }}
              href="mailto:support@stolk.app"
            >
              support@stolk.app
            </a>
            <a style={{ textDecoration: "underline" }} href="tel:070-1740605">
              070-1740605
            </a>
          </div>
        </CenteredFooter>
      </Section>
    </Background>
  );
};

export { Footer };
