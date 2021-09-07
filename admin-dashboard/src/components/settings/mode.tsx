import { FC } from "react";
import { Check } from "react-feather";
import { TTheme } from "../../utils/types";
import { StyledMode, StyledSkinName } from "./style";

interface IProps {
    mode: TTheme;
    onClick: () => void;
    active?: boolean;
}

const Mode: FC<IProps> = ({ active, mode, onClick }) => {
    return (
        <>
            <StyledMode
                type="button"
                $mode={mode}
                data-title={mode}
                $active={active}
                onClick={onClick}
            >
                <Check width={14} height={14} />
                <span />
                <span />
            </StyledMode>
            <StyledSkinName>{mode}</StyledSkinName>
        </>
    );
};

export default Mode;
