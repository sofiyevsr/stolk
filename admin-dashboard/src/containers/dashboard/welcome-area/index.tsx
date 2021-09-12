import { FC, useState } from "react";
import { Plus } from "react-feather";
import Breadcrumb from "../../../components/breadcrumb";
import ModalCreateTicket from "../../../components/dashboard/modal-create-ticket";
import {
  StyledWelcomeArea,
  StyledWelcomeLeft,
  StyledWelcomeRight,
  StyledButton,
} from "./style";

const WelcomeArea: FC = () => {
  const [showTicketModal, setShowTicketModal] = useState(false);
  const handleTicketModal = () => {
    setShowTicketModal((prev) => !prev);
  };
  return (
    <>
      <StyledWelcomeArea>
        <StyledWelcomeLeft>
          <Breadcrumb prev={[]} title="Home" wcText="Welcome" />
        </StyledWelcomeLeft>
        <StyledWelcomeRight>
          <StyledButton size="sm" ml="10px" hasIcon onClick={handleTicketModal}>
            <Plus />
            Add New Ticket
          </StyledButton>
        </StyledWelcomeRight>
      </StyledWelcomeArea>
      <ModalCreateTicket show={showTicketModal} onClose={handleTicketModal} />
    </>
  );
};

export default WelcomeArea;
