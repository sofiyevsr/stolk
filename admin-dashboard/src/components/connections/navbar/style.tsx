import styled, { themeGet } from "../../../utils/styled";
import { NavLink } from "../../../widgets";

export const StyledNavLink = styled(({ ...rest }) => <NavLink {...rest} />)`
    align-items: center;
    display: flex;
    &.active {
        font-weight: 500;
        .badge {
            background-color: ${themeGet("colors.info")};
            color: #fff;
        }
    }

    .badge {
        margin-left: 10px;
        background-color: ${themeGet("colors.light")};
        color: ${themeGet("colors.text3")};
    }
`;
