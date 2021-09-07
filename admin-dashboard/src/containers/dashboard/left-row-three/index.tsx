import { FC } from "react";
import { Col } from "../../../widgets";
import RecentActivities from "../../../components/dashboard/recent-activities";

const LeftRowThree: FC = () => {
    return (
        <>
            <Col md={12} mt="10px">
                <RecentActivities />
            </Col>
        </>
    );
};

export default LeftRowThree;
