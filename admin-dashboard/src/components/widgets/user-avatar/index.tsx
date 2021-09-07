import { FC } from "react";
import { Avatar } from "../../../widgets";
import image from "../../../utils/images/img16.jpg";

const UserAvatar: FC = () => {
    return (
        <Avatar size="xxl" status="online">
            <img src={image} alt="user" />
        </Avatar>
    );
};

export default UserAvatar;
