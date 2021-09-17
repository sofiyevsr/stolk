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
};

const categoryApi = new CategoriesApi();
function AddCategoryModal({ show, onClose, alterInMemory }: Props) {
  const {
    register,
    handleSubmit,
    formState: { isSubmitting, errors },
  } = useForm<FormData>();

  const formHandler = async (data: FormData) => {
    const res: any = await categoryApi.insert({ name: data.name });
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
      <label htmlFor="category-name">Name</label>
      <input
        id="category-name"
        {...register("name", {
          maxLength: { message: "Maximum 8 length", value: 8 },
          minLength: { message: "Minimum 2 length", value: 2 },
          required: { message: "Name is required", value: true },
        })}
      />
      <span style={{ color: "red" }}>{errors.name && errors.name.message}</span>
    </Modal>
  );
}

export default AddCategoryModal;
