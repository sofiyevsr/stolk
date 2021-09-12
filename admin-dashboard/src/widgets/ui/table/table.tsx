import { FC, ReactElement } from "react";
import classNames from "classnames";
import { SpaceProps, BorderProps } from "../../../utils/styled";
import { StyledTableResponsive, StyledTable } from "./style";

type TColor =
  | "primary"
  | "secondary"
  | "success"
  | "danger"
  | "warning"
  | "info"
  | "light"
  | "dark";

interface IProps extends SpaceProps, BorderProps {
  children: ReactElement;
  className?: string;
  theadColor?: TColor;
  striped?: boolean;
  bordered?: boolean;
  hover?: boolean;
  compact?: boolean;
  color?: TColor;
  borderless?: boolean;
}

export const Table: FC<IProps> = ({
  children,
  className,
  theadColor,
  striped,
  bordered,
  hover,
  compact,
  color,
  borderless,
  ...restProps
}) => {
  return <StyledTableResponsive>{children}</StyledTableResponsive>;
};
