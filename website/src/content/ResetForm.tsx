import React, { useState } from "react";
import SuccessContainer from "../containers/Success";
import { Section } from "../layout/Section";
import { useForm } from "react-hook-form";
import { useTranslation } from "next-i18next";
import { API_URL, passwordRegex } from "../utils/constants";
import { useRouter } from "next/router";
import { toast } from "react-toastify";

interface FormData {
  password: string;
  repeatPassword: string;
}

function ResetForm() {
  const { t } = useTranslation();
  const [operationDone, setOperationDone] = useState(false);
  const router = useRouter();
  const {
    register,
    watch,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<FormData>();
  if (operationDone === true) {
    return (
      <Section>
        <SuccessContainer />
      </Section>
    );
  }

  const onSubmit = async (data: FormData) => {
    const { t: token, i: id } = router.query;
    try {
      const res = await fetch(API_URL + "auth/reset-password", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          token,
          id,
          password: data.password,
        }),
      });
      if (res?.status === 200) setOperationDone(true);
      else {
        toast.error(t("general.error"));
      }
    } catch (error) {
      toast.error(t("general.error"));
    }
  };

  return (
    <Section>
      <div className="text-2xl font-black text-center">
        {t("reset-password.title")}
      </div>
      <form
        onSubmit={handleSubmit(onSubmit)}
        className="flex flex-col items-center"
      >
        <div className="mt-5">
          <label htmlFor="password">{t("fields.password")}</label>
          <input
            autoComplete={"new-password"}
            placeholder={t("fields.password_placeholder")}
            className="block w-full border-gray-300 md:w-80 rounded-md shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50"
            type="password"
            id="password"
            {...register("password", {
              required: {
                value: true,
                message: t("errors.password_required"),
              },
              pattern: {
                value: passwordRegex,
                message: t("errors.password_pattern"),
              },
            })}
          />
          {errors.password && (
            <h2 className="max-w-xs text-red-500">{errors.password.message}</h2>
          )}
        </div>
        <div className="mt-5">
          <label htmlFor="repassword">{t("fields.repassword")}</label>
          <input
            autoComplete={"new-password"}
            placeholder={t("fields.repassword_placeholder")}
            className="block w-full border-gray-300 md:w-80 rounded-md shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50"
            type="password"
            id="repassword"
            {...register("repeatPassword", {
              required: {
                value: true,
                message: t("errors.repassword_required"),
              },
              pattern: {
                value: passwordRegex,
                message: t("errors.repassword_pattern"),
              },
              validate: (value) =>
                value === watch("password") ||
                (t("errors.password_match") as string),
            })}
            onPaste={(e) => {
              e.preventDefault();
              return false;
            }}
          />
          {errors.repeatPassword && (
            <h2 className="max-w-xs text-red-500">
              {errors.repeatPassword.message}
            </h2>
          )}
        </div>
        <button
          disabled={isSubmitting}
          className="px-4 py-2 mt-5 font-bold text-white bg-blue-500 rounded hover:bg-blue-700"
          type="submit"
        >
          {t("general.submit")}
        </button>
      </form>
    </Section>
  );
}

export default ResetForm;
