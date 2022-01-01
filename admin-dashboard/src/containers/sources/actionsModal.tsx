import { useForm } from "react-hook-form";
import { toast } from "react-toastify";
import SourcesApi from "../../utils/api/sources";
import { Modal } from "../../widgets";

interface Props {
  show: boolean;
  onClose: () => void;
  modifyItem: (index: number, item: { [key: string]: any }) => void;
  addItem: (item: { [key: string]: any }) => void;
  sourceID?: number;
}

type FormData = {
  name: string;
  logo_suffix: string;
  link: string;
  lang_id: string;
  category_alias_name?: string;
};

const langs = [
  { id: 0, name: "az" },
  { id: 1, name: "tr" },
  { id: 2, name: "ru" },
  { id: 3, name: "en" },
];

const sourcesApi = new SourcesApi();

function SourceActionsModal({
  show,
  onClose,
  addItem,
  modifyItem,
  sourceID,
}: Props) {
  const {
    register,
    handleSubmit,
    reset,
    formState: { isSubmitting, errors },
  } = useForm<FormData>();

  const formHandler = async (data: FormData) => {
    if (sourceID == null) {
      const res: any = await sourcesApi.create({
        name: data.name,
        logo_suffix: data.logo_suffix,
        link: data.link,
        lang_id: data.lang_id,
        category_alias_name: data.category_alias_name,
      });
      toast.success("Source created");
      addItem(res.body);
    } else {
      const res: any = await sourcesApi.update({
        id: sourceID,
        name: data.name,
        logo_suffix: data.logo_suffix,
        link: data.link,
        lang_id: data.lang_id,
        category_alias_name: data.category_alias_name,
      });
      toast.success("Source updated");
      modifyItem(sourceID, res.body);
    }
    reset({
      name: "",
      logo_suffix: "",
      link: "",
      lang_id: "",
      category_alias_name: "",
    });
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
      <label htmlFor="name">Name</label>
      <input
        id="name"
        {...register("name", {
          maxLength: { message: "Maximum 20 length", value: 20 },
          minLength: { message: "Minimum 2 length", value: 2 },
          required: { message: "Name is required", value: true },
        })}
      />
      <div style={{ color: "red" }}>{errors.name && errors.name.message}</div>

      <label htmlFor="link">Link</label>
      <input
        id="link"
        {...register("link", {
          minLength: { message: "Minimum 2 length", value: 2 },
          required: { message: "Link is required", value: true },
        })}
      />
      <div style={{ color: "red" }}>{errors.link && errors.link.message}</div>

      <label htmlFor="lang_id">Language</label>
      <select
        id="lang_id"
        {...register("lang_id", {
          required: { message: "Language is required", value: true },
        })}
      >
        {langs.map(({ id, name }) => (
          <option key={id} value={id}>
            {name}
          </option>
        ))}
      </select>
      <div style={{ color: "red" }}>
        {errors.lang_id && errors.lang_id.message}
      </div>

      <label htmlFor="category_alias_name">Category alias name</label>
      <input
        id="category_alias_name"
        {...register("category_alias_name", {
          maxLength: { message: "Maximum 20 length", value: 20 },
          minLength: { message: "Minimum 2 length", value: 2 },
          required: { message: "Category alias name is required", value: true },
        })}
      />
      <div style={{ color: "red" }}>
        {errors.category_alias_name && errors.category_alias_name.message}
      </div>

      <label htmlFor="logo-suffix">Logo filename (example: image.jpg)</label>
      <input
        id="logo-suffix"
        {...register("logo_suffix", {
          minLength: { message: "Minimum 2 length", value: 2 },
          required: { message: "Logo suffix is required", value: true },
        })}
      />
      <div style={{ color: "red" }}>
        {errors.logo_suffix && errors.logo_suffix.message}
      </div>
    </Modal>
  );
}

export default SourceActionsModal;
