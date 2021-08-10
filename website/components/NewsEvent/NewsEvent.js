import React from "react";
import PropTypes from "prop-types";
import { useTheme } from "@material-ui/core/styles";
import Typography from "@material-ui/core/Typography";
import { useText } from "~/theme/common";
import { withTranslation } from "~/i18n";
import ParallaxLarge from "../Parallax/Large";
import useStyle from "./news-event-style";

function NewsEvent(props) {
  const classes = useStyle();
  const text = useText();
  const { t } = props;

  return (
    <div className={classes.root}>
      <div className={classes.decoBgTop} />
    </div>
  );
}

NewsEvent.propTypes = {
  t: PropTypes.func.isRequired,
};

export default withTranslation(["mobile-landing"])(NewsEvent);
