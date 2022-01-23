import { useEffect } from "react";
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
  defaultValues?: any;
}

type FormData = {
  name: string;
  logo_suffix: string;
  link: string;
  image: File[] | null;
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
  defaultValues,
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
    setValue,
    formState: { isSubmitting, errors },
  } = useForm<FormData>(defaultValues);

  const formHandler = async (data: FormData) => {
    if (sourceID == null) {
      const res: any = await sourcesApi.create({
        name: data.name,
        logo_suffix: data.logo_suffix,
        link: data.link,
        lang_id: data.lang_id,
        category_alias_name: data.category_alias_name,
        image: data.image![0],
      });
      toast.success("Source created");
      addItem(res.body);
    } else {
      const res: any = await sourcesApi.update({
        id: sourceID,
        name: data.name,
        logo_suffix: data.logo_suffix,
        link: data.link,
        image: data.image![0],
        lang_id: data.lang_id,
        category_alias_name: data.category_alias_name,
      });
      toast.success("Source updated");
      modifyItem(sourceID, res.body);
    }
    reset({
      image: null,
      link: "",
      name: "",
      lang_id: "",
      logo_suffix: "",
      category_alias_name: "",
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
        })}
      />
      <div style={{ color: "red" }}>
        {errors.category_alias_name && errors.category_alias_name.message}
      </div>
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
      </div>{" "}
      <label htmlFor="logo-suffix">Logo filename (example: image.jpg, keeping old filename recommended to replace old image)</label>
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
