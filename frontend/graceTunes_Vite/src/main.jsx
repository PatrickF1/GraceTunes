import React from "react"
import ReactDOM from "react-dom/client.js"
import { Provider } from "react-redux"
import App from "./App.jsx"
import store from "./store/index.js"

const container = document.getElementById("root")
const root = ReactDOM.createRoot(container)
root.render(
  <React.StrictMode>
    <Provider store={store}>
      <App />
    </Provider>
  </React.StrictMode>
)
