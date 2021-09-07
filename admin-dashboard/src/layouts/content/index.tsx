import React from "react";
import { SpaceProps, BorderProps } from "../../utils/styled";
import { Container } from "../../widgets";
import { StyledContent } from "./style";

interface IProps extends SpaceProps, BorderProps {
    className?: string;
    fullHeight?: boolean;
    align?: "top" | "center" | "bootom";
}

const Content: React.FC<IProps> = ({
    children,
    className,
    fullHeight,
    align,
    ...restProps
}) => {
    return (
        <StyledContent
            $fullHeight={fullHeight}
            $align={align}
            className={className}
            {...restProps}
        >
            <Container className="container" pl="0" pr="0">
                {children}
            </Container>
        </StyledContent>
    );
};

export default Content;
