import styled from "../../../utils/styled";
import { CardHeader } from "../../../widgets";

export const StyledHeader = styled(({ ...rest }) => <CardHeader {...rest} />)`
    padding-left: 20px;
    padding-right: 20px;
    padding-top: 15px;
    padding-bottom: 15px;
    display: flex;
    justify-content: space-between;
    align-items: center;
`;
