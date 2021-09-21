import TextField from "@material-ui/core/TextField";
import Autocomplete from "@material-ui/lab/Autocomplete";
import { useEffect, useState } from "react";
import { toast } from "react-toastify";
import CategoriesApi from "../../utils/api/categories";
import CategoryAliasesApi from "../../utils/api/categories-aliases";
import { Modal } from "../../widgets";

interface Props {
  show: boolean;
  onClose: () => void;
  alterInMemory: (item: { [key: string]: any }) => void;
  categoryAliasID: number;
}


const categoryApi = new CategoriesApi();
const categoryAliasesApi = new CategoryAliasesApi();

function LinkCategoryModal({
  show,
  onClose,
  alterInMemory,
  categoryAliasID,
}: Props) {
  const [categories, setCategories] = useState<
    { id: number | null; name: string }[]
  >([]);
  const [isLoading, setLoading] = useState(true);
  const [requestSent, setRequestSent] = useState(false);
  const [selectedCategory, setSelectedCategory] = useState<{
    id: null | number;
    name: string;
  } | null>(null);
  useEffect(() => {
    categoryApi
      .getAll({ lastID: null })
      .then(({ body: { categories } }) => {
        setLoading(false);
        setCategories(categories);
      })
      .catch(() => {});
  }, []);
  return (
    <Modal
      show={show}
      onClose={onClose}
      onAction={async () => {
        if (typeof selectedCategory === "undefined") {
          toast.error("No category selected");
          throw Error();
        }
        try {
          setRequestSent(true);
          await categoryAliasesApi.link({
            category_alias_id: categoryAliasID,
            category_id: selectedCategory?.id ?? null,
          });
          alterInMemory({ category_id: selectedCategory?.id });
          toast.success("Category linked");
        } catch (error) {
        } finally {
          setRequestSent(false);
        }
      }}
    >
      <Autocomplete
        loading={isLoading}
        value={selectedCategory}
        options={categories}
        getOptionLabel={(option) => option.name}
        disabled={requestSent}
        onChange={(_, value) => {
          setSelectedCategory(value);
        }}
        style={{ width: 300 }}
        renderInput={(params) => (
          <TextField {...params} label="Choose category" variant="outlined" />
        )}
      />
      <span>Leave empty for breaking link</span>
    </Modal>
  );
}

export default LinkCategoryModal;
