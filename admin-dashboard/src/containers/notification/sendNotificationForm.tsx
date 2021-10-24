import { TextField } from "@material-ui/core";
import { Controller, useForm } from "react-hook-form";
import { toast } from "react-toastify";
import NotificationApi from "../../utils/api/notification";
import { Button, Card, CardBody } from "../../widgets";
import { StyledHeader } from "../../widgets/ui/modal/style";

interface FormData {
  title: string;
  body: string;
}

const api = new NotificationApi();
function SendNotificationForm() {
  const {
    control,
    handleSubmit,
    formState: { isSubmitting, errors },
  } = useForm<FormData>();

  const onSubmit = async (data: FormData) => {
    try {
      const { body } = await api.sendToEveryone(data);
      toast.success(`Notifications sent,
                    \nsuccess: ${body.success_count}
                    \nfailure: ${body.failure_count}
                    \ndeleted stale tokens: ${body.deleted_count}`);
    } catch (error) {}
  };
  return (
    <Card>
      <StyledHeader>Send notification to everyone</StyledHeader>
      <CardBody>
        <form onSubmit={handleSubmit(onSubmit)}>
          <div>
            <Controller
              name="title"
              control={control}
              rules={{
                required: {
                  message: "Title required",
                  value: true,
                },
              }}
              render={({ field: { ref, ...field } }) => (
                <TextField
                  error={!!errors.title}
                  helperText={errors.title?.message}
                  style={{ minWidth: "30%" }}
                  variant="outlined"
                  aria-invalid={!!errors.title}
                  innerRef={ref}
                  label="Title"
                  {...field}
                />
              )}
            />
          </div>
          <div style={{ margin: "20px 0" }}>
            <Controller
              name="body"
              control={control}
              rules={{
                required: {
                  message: "Body required",
                  value: true,
                },
              }}
              render={({ field: { ref, ...field } }) => (
                <TextField
                  error={!!errors.body}
                  helperText={errors.body?.message}
                  style={{ minWidth: "50%" }}
                  variant="outlined"
                  label="Body"
                  multiline
                  rows={6}
                  innerRef={ref}
                  {...field}
                />
              )}
            />
          </div>
          <div style={{ margin: "10px 0" }}>
            <Button disabled={isSubmitting} type="submit">
              Send
            </Button>
          </div>
        </form>
      </CardBody>
    </Card>
  );
}

export default SendNotificationForm;
