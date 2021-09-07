import { FC } from "react";
import { Image, Text } from "../../../widgets";
import image1 from "../../../utils/images/img10.jpg";
import image2 from "../../../utils/images/img11.jpg";
import image3 from "../../../utils/images/img12.jpg";
import image4 from "../../../utils/images/img13.jpg";
import image5 from "../../../utils/images/img9.jpg";
import WidgetTitle from "../widget-title";
import { StyledImgGroup } from "./style";

const MutualConnections: FC = () => {
    return (
        <>
            <WidgetTitle title="Mutual Connections" />
            <StyledImgGroup>
                <Image src={image1} alt="group" shape="circle" />
                <Image src={image2} alt="group" shape="circle" />
                <Image src={image3} alt="group" shape="circle" />
                <Image src={image4} alt="group" shape="circle" />
                <Image src={image5} alt="group" shape="circle" />
            </StyledImgGroup>
            <h6>You have 18 mutual connection</h6>
            <Text color="text3">
                You and Fen both know Archie Cantones, Socrates Itumay, and 17
                others
            </Text>
        </>
    );
};

export default MutualConnections;
