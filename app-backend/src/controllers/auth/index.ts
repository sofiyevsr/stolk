import login from "./loginUser";
import register from "./registerUser";
import logout from "./logout";
import checkToken from "./checkToken";
import {
  resetPassword,
  validateResetToken,
  createResetToken,
} from "./resetToken";

export default {
  logout,
  resetPassword,
  validateResetToken,
  createResetToken,
  login,
  register,
  checkToken,
};
