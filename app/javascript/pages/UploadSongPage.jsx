import React from 'react'
import UploadSongForm from '../components/UploadSongForm'
import { Stack } from '@mui/material'

function UploadSongPage() {
    return (
        <Stack className="container upload-song-page" direction="column" spacing={3} alignItems="center">
            <h1>Upload a Song</h1>
            <hr />
            <UploadSongForm />
        </Stack>
    )
}

export default UploadSongPage