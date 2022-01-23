import { Fragment, useEffect } from "react";
import { useForm } from "react-hook-form";
import { toast } from "react-toastify";
import CategoriesApi from "../../utils/api/categories";
import NewsApi from "../../utils/api/news";
import { Modal } from "../../widgets";

interface Props {
  show: boolean;
  onClose: () => void;
}

type FormData = {
  older_than: number | null;
  keep_bookmarks: string;
};

const newsApi = new NewsApi();
const defaultValues: FormData = {
  keep_bookmarks: "true",
  older_than: null,
};

function CleanupModal({ show, onClose }: Props) {
  const {
    register,
    handleSubmit,
    reset,
    formState: { isSubmitting, errors },
  } = useForm<FormData>({ defaultValues: defaultValues });

  const formHandler = async (data: FormData) => {
    const res = await newsApi.delete(data.older_than!, data.keep_bookmarks);
    toast.success(`Cleanup done! ${res.body.deletedRows} rows deleted`);
    reset(defaultValues);
  };

  return (
    <Modal
      show={show}
      onClose={onClose}
      buttonDisabled={isSubmitting}
      onAction={handleSubmit(formHandler, (e) => {
        throw e;
      })}
    >
      <label htmlFor="older_than">Delete news older than</label>
      <input
        id="older_than"
        type="number"
        placeholder="e.g 1 for 1 month"
        min={1}
        max={12}
        {...register("older_than", {
          max: {
            message: "Max 12",
            value: 12,
          },
          min: {
            message: "Min 1",
            value: 1,
          },
          required: {
            message:
              "Enter amount of months you want to delete news older than",
            value: true,
          },
        })}
      />
      <div style={{ color: "red" }}>
        {errors.older_than && errors.older_than.message}
      </div>
      <label>
        Keep news which has at least one bookmark (recommended to keep)
      </label>
      <br />
      <div
        style={{
          display: "inline-flex",
          justifyContent: "center",
          alignItems: "center",
        }}
      >
        <label htmlFor="keep_yes">Yes</label>
        <input
          id="keep_yes"
          type="radio"
          style={{ width: "20px", margin: "0 5px" }}
          value="true"
          {...register("keep_bookmarks", {
            required: { message: "Required", value: true },
          })}
        />
      </div>
      <div
        style={{
          display: "inline-flex",
          justifyContent: "center",
          alignItems: "center",
        }}
      >
        <label htmlFor="keep_no">No</label>
        <input
          id="keep_no"
          type="radio"
          value="false"
          style={{ width: "20px", margin: "0 5px" }}
          {...register("keep_bookmarks", {
            required: { message: "Required", value: true },
          })}
        />
      </div>
      <div style={{ color: "red" }}>
        {errors.keep_bookmarks && errors.keep_bookmarks.message}
      </div>
    </Modal>
  );
}

export default CleanupModal;
