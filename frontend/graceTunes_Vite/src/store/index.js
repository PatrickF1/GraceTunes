import { configureStore } from "@reduxjs/toolkit"
import logger from "redux-logger"
import placeholderReducer from "../components/Placeholder/placeholderSlice"

const rootReducer = {
  // your slices will go here
}

const store = configureStore({
  reducer: {
    placeholder: placeholderReducer,
  },
  middleware: (getDefaultMiddleware) => getDefaultMiddleware().concat(logger),
})

export default store
