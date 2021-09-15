import { FC } from "react";
import { Portal } from "react-portal";
import classnames from "classnames";
import { CSSTransition } from "react-transition-group";
import { SpaceProps } from "../../../utils/styled";
import {
  StyledBackdrop,
  StyledModal,
  StyledHeader,
  StyledTitle,
  StyledClose,
  StyledBody,
  StyledFooter,
} from "./style";
import { Button } from "../button/button";

export interface IProps {
  /**
   * Pass extra classes
   */
  className?: string;
}

export interface IModal extends IProps {
  /**
   * When `true` The modal will show itself.
   */
  show: boolean;
  /**
   * Modal Sizes
   */
  size?: "xl" | "lg" | "md" | "sm";
  /**
   * vertically center the Dialog in the window
   */
  centered?: boolean;
  /**
   * Callback function for close modal
   */
  onClose: () => void;
  onAction: () => Promise<any>;
}

export const Modal: FC<IModal> = ({
  className,
  show,
  size,
  centered,
  children,
  onClose,
  onAction,
  ...restProps
}) => {
  return (
    <Portal>
      <>
        <StyledBackdrop $show={show} />
        <StyledModal
          $show={show}
          $size={size}
          $centered={centered}
          className={classnames(className)}
          onClick={onClose}
          {...restProps}
        >
          <CSSTransition
            in={show}
            timeout={400}
            unmountOnExit
            classNames="modal"
          >
            {() => (
              <div className="modal-dialog">
                <div
                  className="modal-content"
                  onClick={(e) => e.stopPropagation()}
                  role="button"
                  tabIndex={0}
                >
                  <ModalHeader>
                    <ModalTitle>Action Required</ModalTitle>
                    <ModalClose onClose={onClose}>x</ModalClose>
                  </ModalHeader>
                  <ModalBody>{children}</ModalBody>
                  <ModalFooter>
                    <Button color="secondary" onClick={onClose}>
                      Close
                    </Button>
                    <Button
                      color="primary"
                      onClick={async () => {
                        try {
                          await onAction();
                          onClose();
                        } catch (error) {}
                      }}
                    >
                      Save changes
                    </Button>
                  </ModalFooter>
                </div>
              </div>
            )}
          </CSSTransition>
        </StyledModal>
      </>
    </Portal>
  );
};

Modal.defaultProps = {
  size: "md",
  centered: true,
};

export const ModalHeader: FC<IProps> = ({
  className,
  children,
  ...restProps
}) => {
  return (
    <StyledHeader
      className={classnames(className, "modal-header")}
      {...restProps}
    >
      {children}
    </StyledHeader>
  );
};

export const ModalTitle: FC<IProps> = ({
  className,
  children,
  ...restProps
}) => {
  return (
    <StyledTitle
      className={classnames(className, "modal-title")}
      {...restProps}
    >
      {children}
    </StyledTitle>
  );
};

interface IClose extends IProps {
  onClose?: () => void;
}

export const ModalClose: FC<IClose> = ({
  className,
  children,
  onClose,
  ...restProps
}) => {
  return (
    <StyledClose
      type="button"
      className={classnames(className, "close")}
      onClick={onClose}
      {...restProps}
      data-dismiss="modal"
      aria-label="Close"
    >
      <span aria-hidden="true">{children}</span>
    </StyledClose>
  );
};

ModalClose.displayName = "ModalClose";

interface IBody extends IProps, SpaceProps {}

export const ModalBody: FC<IBody> = ({ className, children, ...restProps }) => {
  return (
    <StyledBody className={classnames(className, "modal-body")} {...restProps}>
      {children}
    </StyledBody>
  );
};

export const ModalFooter: FC<IProps> = ({
  className,
  children,
  ...restProps
}) => {
  return (
    <StyledFooter
      className={classnames(className, "modal-body")}
      {...restProps}
    >
      {children}
    </StyledFooter>
  );
};
