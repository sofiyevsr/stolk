import styled, { themeGet } from "../../../utils/styled";
import { TabWrap } from "../../../widgets";

export const StyledTabsWrap = styled(({ ...rest }) => <TabWrap {...rest} />)`
    .react-tabs {
        &__tab {
            .badge {
                background-color: ${themeGet("colors.light")};
                color: ${themeGet("colors.text3")};
            }
            &--selected {
                .badge {
                    background-color: ${themeGet("colors.info")};
                    color: #fff;
                }
            }
        }
    }
`;
