import { configureStore, combineReducers } from "@reduxjs/toolkit";
import uiReducer from "./slices/ui";
import userReducer from "./slices/user";

const rootReducer = combineReducers({
  ui: uiReducer,
  user: userReducer,
});

export const store = configureStore({
  reducer: rootReducer,
});

// Infer the `RootState` and `AppDispatch` types from the store itself
export type RootState = ReturnType<typeof store.getState>;
// Inferred type: {posts: PostsState, comments: CommentsState, users: UsersState}
export type AppDispatch = typeof store.dispatch;
