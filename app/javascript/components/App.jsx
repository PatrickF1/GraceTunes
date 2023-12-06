import React from 'react'
import { createBrowserRouter, createRoutesFromElements, Navigate, Route, RouterProvider } from "react-router-dom";

import RootLayout from '../layouts/RootLayout'
import AboutPage from '../pages/AboutPage';
import RequestSongPage from '../pages/RequestSongPage';
import UploadSongPage from '../pages/UploadSongPage';

const router = createBrowserRouter(
  createRoutesFromElements(
    <Route path="/" element={<RootLayout />}>
      <Route exact path="/" element={<Navigate to="/songs" />} />
      <Route path="/songs" element={<div>songs</div>} />
      <Route path="/about" element={<AboutPage />} />
      <Route path="/history" element={<div>Audit page</div>} />
      <Route path="/songs/new" element={<UploadSongPage />} />
      <Route path="/request-song" element={<RequestSongPage />} />
    </Route>
  )
)

function App() {
  return (
    <RouterProvider router={router} />
  )
}

export default App