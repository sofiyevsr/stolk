import { FC, useState, useCallback, useEffect } from "react";
import { Menu, X, ArrowLeft } from "react-feather";
import { Navbar, Button } from "../../widgets";
import menuData from "../../utils/data/menu";
import ProfileDropdown from "../../components/header/profile-dropdown";
import Logo from "../../components/logo";
import { useAppDispatch, useAppSelector } from "../../redux/hooks";
import { toggleSidebar, toggleBody } from "../../redux/slices/ui";
import {
  StyledHeader,
  StyledLogo,
  StyledNavbarWrap,
  StyledNavbarMenu,
  StyleNavbarRight,
  StyledNavbarElement,
  StyledNavbarHeader,
  StyledNavbarBody,
  StyledNavbarTitle,
  StyledMenuBtn,
  StyledSidebarBtn,
} from "./style";

interface IProps {
  hasSidebar?: boolean;
}

const Header: FC<IProps> = ({ hasSidebar }) => {
  const dispatch = useAppDispatch();
  const { sidebar } = useAppSelector((state) => state.ui);
  const [menuOpen, setMenuOpen] = useState(false);
  const sidebarHandler = useCallback(
    (_, isOpen?: "open") => {
      dispatch(toggleSidebar({ isOpen }));
    },
    [dispatch]
  );

  const bodyHandler = useCallback(() => {
    dispatch(toggleBody());
    dispatch(toggleSidebar({ isOpen: "open" }));
  }, [dispatch]);

  const menuHandler = useCallback(() => {
    setMenuOpen((prev) => !prev);
    if (menuOpen) {
      sidebarHandler(undefined, "open");
    }
  }, [menuOpen, sidebarHandler]);

  useEffect(() => {
    return () => {
      sidebarHandler(undefined, "open");
      bodyHandler();
    };
  }, [sidebarHandler, bodyHandler]);

  return (
    <>
      <StyledHeader>
        {hasSidebar && (
          <>
            <StyledMenuBtn
              variant="texted"
              onClick={menuHandler}
              $hasSidebar={hasSidebar}
              $sidebarOpen={!sidebar}
            >
              <Menu size={20} strokeWidth="2.5px" />
            </StyledMenuBtn>
            <StyledSidebarBtn
              variant="texted"
              onClick={sidebarHandler}
              $sidebarOpen={!sidebar}
            >
              <ArrowLeft size={20} strokeWidth="2.5px" />
            </StyledSidebarBtn>
          </>
        )}
        {!hasSidebar && (
          <StyledMenuBtn
            variant="texted"
            onClick={menuHandler}
            $hasSidebar={hasSidebar}
            $sidebarOpen={!sidebar}
          >
            <Menu size={20} strokeWidth="2.5px" />
          </StyledMenuBtn>
        )}
        <StyledLogo>
          <Logo />
        </StyledLogo>
        <StyledNavbarWrap $isOpen={menuOpen} onClick={menuHandler}>
          <StyledNavbarMenu
            $isOpen={menuOpen}
            onClick={(e: any) => e.stopPropagation()}
          >
            <StyledNavbarHeader>
              <Logo />
              <Button variant="texted" onClick={menuHandler}>
                <X color="#7987a1" width={20} strokeWidth="2.5px" />
              </Button>
            </StyledNavbarHeader>
            <StyledNavbarBody>
              <StyledNavbarTitle>MAIN NAVIGATION</StyledNavbarTitle>
              <Navbar menus={menuData} />
            </StyledNavbarBody>
          </StyledNavbarMenu>
        </StyledNavbarWrap>
        <StyleNavbarRight>
          <StyledNavbarElement ml={["15px", "20px", "30px"]}>
            <ProfileDropdown />
          </StyledNavbarElement>
        </StyleNavbarRight>
      </StyledHeader>
    </>
  );
};

export default Header;
