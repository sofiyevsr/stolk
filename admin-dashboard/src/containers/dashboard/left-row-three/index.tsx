import { FC } from "react";
import { Col } from "../../../widgets";
import Analytics from "../../../components/dashboard/analytics";

const LeftRowThree: FC = () => {
  return (
    <>
      <Col md={12} mt="10px">
        <Analytics />
      </Col>
    </>
  );
};

export default LeftRowThree;
