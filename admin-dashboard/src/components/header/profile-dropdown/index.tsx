import React from "react";
import { LogOut } from "react-feather";
import { useAppSelector } from "../../../redux/hooks";
import AuthApi from "../../../utils/api/auth";
import {
  DropdownToggle,
  Dropdown,
  Avatar,
  AvatarInitial,
  Button,
} from "../../../widgets";
import {
  StyledDropMenu,
  StyledAuthorName,
  StyledAuthorRole,
  StyledAvatar,
} from "./style";

const authService = new AuthApi();
const ProfileDropdown: React.FC = () => {
  const user = useAppSelector((state) => state.user);
  if (user.isAuthorized !== true) return null;
  return (
    <Dropdown direction="down" className="dropdown-profile">
      <DropdownToggle variant="texted">
        <StyledAvatar size="sm" shape="circle">
          <AvatarInitial>RS</AvatarInitial>
        </StyledAvatar>
      </DropdownToggle>
      <StyledDropMenu>
        <Avatar size="lg" shape="circle">
          <AvatarInitial>RS</AvatarInitial>
        </Avatar>
        {user.data && (
          <StyledAuthorName>
            {user.data.first_name + " " + user.data.last_name}
          </StyledAuthorName>
        )}
        <StyledAuthorRole>Administrator</StyledAuthorRole>
        <Button
          onClick={() => {
            authService.logout().catch((e) => {});
          }}
        >
          <LogOut size="24" style={{ margin: "0 10px" }} />
          Sign Out
        </Button>
      </StyledDropMenu>
    </Dropdown>
  );
};

export default ProfileDropdown;
