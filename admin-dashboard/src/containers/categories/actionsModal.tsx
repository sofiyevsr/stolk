import { Fragment, useEffect } from "react";
import { useForm } from "react-hook-form";
import { toast } from "react-toastify";
import CategoriesApi from "../../utils/api/categories";
import { Modal } from "../../widgets";

interface Props {
  show: boolean;
  onClose: () => void;
  modifyItem: (index: number, item: { [key: string]: any }) => void;
  addItem: (item: { [key: string]: any }) => void;
  categoryID?: number;
  defaultValues?: any;
}

type FormData = {
  name_en: string;
  name_ru: string;
  name_az: string;
  image_suffix: string;
  image: File[] | null;
};

const categoryApi = new CategoriesApi();
const nameFields = {
  name_az: "Name in AZ",
  name_ru: "Name in RU",
  name_en: "Name in EN",
};
function CategoryActionsModal({
  show,
  onClose,
  addItem,
  modifyItem,
  defaultValues,
  categoryID,
}: Props) {
  const {
    register,
    handleSubmit,
    setValue,
    reset,
    formState: { isSubmitting, errors, isSubmitSuccessful },
  } = useForm<FormData>();

  const formHandler = async (data: FormData) => {
    if (categoryID == null) {
      const res: any = await categoryApi.insert({
        name_az: data.name_az,
        name_en: data.name_en,
        name_ru: data.name_ru,
        image: data.image![0],
        image_suffix: data.image_suffix,
      });
      toast.success("Category created");
      addItem(res.body);
    } else {
      const res: any = await categoryApi.update({
        id: categoryID,
        name_az: data.name_az,
        name_en: data.name_en,
        name_ru: data.name_ru,
        image: data.image![0],
        image_suffix: data.image_suffix,
      });
      toast.success("Category updated");
      modifyItem(categoryID, res.body);
    }
    reset({
      image: null,
      name_az: "",
      name_en: "",
      name_ru: "",
      image_suffix: "",
    });
  };

  useEffect(() => {
    if (defaultValues) {
      Object.entries(defaultValues).map(([key, value]) =>
        setValue(key as any, value, { shouldValidate: true })
      );
    }
  }, [defaultValues, setValue]);

  return (
    <Modal
      show={show}
      onClose={onClose}
      buttonDisabled={isSubmitting}
      onAction={handleSubmit(formHandler, (e) => {
        throw e;
      })}
    >
      {Object.entries(nameFields).map(([key, value]) => {
        const tKey = key as keyof typeof nameFields;
        return (
          <Fragment key={tKey}>
            <label htmlFor="`category-${tKey}`">{value}</label>
            <input
              id="`category-${tKey}`"
              {...register(tKey, {
                minLength: { message: "Minimum 2 length", value: 2 },
                required: { message: "Name is required", value: true },
              })}
            />
            <div style={{ color: "red" }}>
              {errors[tKey] && errors[tKey]!.message}
            </div>
          </Fragment>
        );
      })}
      <label htmlFor="image">Image (only jpeg, max size 5mb)</label>
      <input
        id="image"
        type="file"
        style={{ paddingTop: "7px" }}
        accept="image/jpeg"
        {...register("image", {
          required: { message: "Image required", value: true },
        })}
      />
      <div style={{ color: "red" }}>
        {errors.image && (errors.image as any).message}
      </div>
      <label htmlFor="image-suffix">
        Image filename (example: image.jpg, reusing old name is recommended as
        it will delete the old image)
      </label>
      <input
        id="image-suffix"
        {...register("image_suffix", {
          minLength: { message: "Minimum 2 length", value: 2 },
          required: { message: "Image suffix is required", value: true },
        })}
      />
      <div style={{ color: "red" }}>
        {errors.image_suffix && errors.image_suffix.message}
      </div>
    </Modal>
  );
}

export default CategoryActionsModal;
