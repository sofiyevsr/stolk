import { Swiper, SwiperSlide } from "swiper/react";
import { Autoplay, Pagination } from "swiper";
import Image from "next/image";
import "swiper/css";
import "swiper/css/pagination";

import React from "react";
import { Section } from "../layout/Section";
import { useTranslation } from "react-i18next";
import { useInView } from "react-intersection-observer";

function PhoneShowcase() {
  const { t } = useTranslation();
  const { ref, inView } = useInView({ triggerOnce: true, threshold: 0.2 });

  return (
    <div ref={ref} className={`${inView ? "animate-reveal" : "scale-0"}`}>
      <Section>
        <h1 className="mb-4 text-5xl text-center">{t("home.screenshots")}</h1>
        <Swiper
          style={{ paddingBottom: "50px" }}
          modules={[Pagination, Autoplay]}
          spaceBetween={50}
          slidesPerView={1}
          pagination={{
            clickable: true,
          }}
          autoplay={{
            delay: 3500,
            pauseOnMouseEnter: true,
            disableOnInteraction: true,
          }}
          breakpoints={{
            640: {
              slidesPerView: 3,
            },
          }}
        >
          {[1, 2, 3, 4, 5].map((_, index) => (
            <SwiperSlide key={index} className="flex justify-center">
              <Image
                src={"/assets/images/empty-phone.png"}
                width="161"
                height="341"
              />
            </SwiperSlide>
          ))}
        </Swiper>
      </Section>
    </div>
  );
}

export default PhoneShowcase;
