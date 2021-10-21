import login from "./loginUser";
import register from "./registerUser";
import logout from "./logout";
import checkToken from "./checkToken";
import completeProfile from "./completeProfile";
import {
  resetPassword,
  validateResetToken,
  createResetToken,
} from "./resetToken";

export default {
  logout,
  resetPassword,
  completeProfile,
  validateResetToken,
  createResetToken,
  login,
  register,
  checkToken,
};
