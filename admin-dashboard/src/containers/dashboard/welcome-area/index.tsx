import { FC } from "react";
import { RefreshCcw } from "react-feather";
import { toast } from "react-toastify";
import Breadcrumb from "../../../components/breadcrumb";
import AnalyticsApi from "../../../utils/api/analytics";
import {
  StyledWelcomeArea,
  StyledWelcomeLeft,
  StyledWelcomeRight,
  StyledButton,
} from "./style";

const analytics = new AnalyticsApi();
const WelcomeArea: FC = () => {
  return (
    <>
      <StyledWelcomeArea>
        <StyledWelcomeLeft>
          <Breadcrumb prev={[]} title="Home" wcText="Analytics" />
        </StyledWelcomeLeft>
        <StyledWelcomeRight>
          <StyledButton
            size="sm"
            ml="10px"
            hasIcon
            onClick={() => {
              analytics
                .refresh()
                .then(() => {
                  toast.success("Update requested, this can take a while");
                })
                .catch(() => {});
            }}
          >
            <RefreshCcw />
            Refresh data on server
          </StyledButton>
        </StyledWelcomeRight>
      </StyledWelcomeArea>
    </>
  );
};

export default WelcomeArea;
