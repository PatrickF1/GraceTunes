import React from 'react'
import { createBrowserRouter, createRoutesFromElements, Navigate, Route, RouterProvider } from "react-router-dom";

import RootLayout from '../layouts/RootLayout'

const router = createBrowserRouter(
  createRoutesFromElements(
    <Route path="/" element={<RootLayout />}>
      <Route exact path="/" element={<Navigate to="/songs" />} />
      <Route path="/songs" element={<div>yay</div>} />
      <Route path="/about" element={<div>about</div>} />
      <Route path="/history" element={<div>Audit page</div>} />
      <Route path="/songs/new" element={<div>Upload song</div>} />
      <Route path="/request-song" element={<div>Request song</div>} />
    </Route>
  )
)

function App() {
  return (
    <RouterProvider router={router} />
  )
}

export default App