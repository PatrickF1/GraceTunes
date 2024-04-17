import React from "react"
import { Routes, Route } from "react-router-dom"
import Home from "./components/home/Home"
import NavBar from "./components/navbar/NavBar"

function App() {
  return (
    <>
      <NavBar />
      <Routes>
        <Route exact path="/songs" element={<Home />} />
      </Routes>
    </>
  )
}

export default App
