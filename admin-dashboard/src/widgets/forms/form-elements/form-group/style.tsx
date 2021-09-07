import styled, { space, SpaceProps } from "../../../../utils/styled";

export const StyledGroup = styled(({ mb, mt, ...rest }) => (
    <div {...rest} />
))<SpaceProps>`
    ${space}
`;
