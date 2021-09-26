import { useForm } from "react-hook-form";
import { toast } from "react-toastify";
import CategoriesApi from "../../utils/api/categories";
import { Modal } from "../../widgets";

interface Props {
  show: boolean;
  onClose: () => void;
  alterInMemory: (item: { [key: string]: any }) => void;
}

type FormData = {
  name: string;
  image_suffix: string;
};

const categoryApi = new CategoriesApi();
function AddCategoryModal({ show, onClose, alterInMemory }: Props) {
  const {
    register,
    handleSubmit,
    reset,
    formState: { isSubmitting, errors },
  } = useForm<FormData>();

  const formHandler = async (data: FormData) => {
    const res: any = await categoryApi.insert({
      name: data.name,
      image_suffix: data.image_suffix,
    });
    reset({ name: "", image_suffix: "" });
    toast.success("Category created");
    alterInMemory(res.body);
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
      <label htmlFor="category-name">
        Name (name should be translated on apps)
      </label>
      <input
        id="category-name"
        {...register("name", {
          maxLength: { message: "Maximum 8 length", value: 8 },
          minLength: { message: "Minimum 2 length", value: 2 },
          required: { message: "Name is required", value: true },
        })}
      />
      <div style={{ color: "red" }}>{errors.name && errors.name.message}</div>
      <label htmlFor="image-suffix">
        Image filename (example: image.jpg)(ideal size 140x80(WxH))
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

export default AddCategoryModal;
