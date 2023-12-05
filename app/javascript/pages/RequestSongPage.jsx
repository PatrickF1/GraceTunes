import React from 'react'

const REQUEST_SONG_URL = 'https://docs.google.com/forms/d/e/1FAIpQLSe7wECdQ9Fp_ttsymZmHIuGs3FbRKKYu5QK_IF4RKULYrjfhA/viewform';

function RequestSongPage() {
    return (
        <div className="general">
            <iframe src={REQUEST_SONG_URL} />
        </div>
    )
}

export default RequestSongPage