/* eslint-disable no-param-reassign */
/* eslint-disable @typescript-eslint/no-unused-expressions */
import { createSlice, PayloadAction } from "@reduxjs/toolkit";

export interface User {
  first_name: string;
  last_name: string;
  email: string;
  token: string;
}

interface State {
  data?: User;
  isAuthorized?: boolean;
}

const initialState: State = {};
const userSlice = createSlice({
  name: "user",
  initialState,
  reducers: {
    login(state, action: PayloadAction<User>) {
      const { payload } = action;
      state.data = payload;
      state.isAuthorized = true;
    },
    logout(state) {
      state.isAuthorized = false;
      delete state.data;
    },
  },
});

export const { logout, login } = userSlice.actions;
export default userSlice.reducer;
