import React from 'react'
import { useForm } from 'react-hook-form'
import {
    Button,
    FormHelperText,
    MenuItem,
    Stack,
} from '@mui/material'
import ReactHookFormSelect from './ReactHookFormSelect'
import ReactHookFormTextField from './ReactHookFormTextField'

function UploadSongForm() {
    const authenticityToken = 'viMSnme2b2gCWzpFl-0acZKJE6n8yAp7PkJ1LR3n0gl6gvlxLr6RKKDy5TvK36jduAy2x1JvEPihjI8dalm1Xw';
    const { handleSubmit, control, formState: { errors } } = useForm({
        defaultValues: {
            name: '',
            artist: '',
            tempo: '',
            bpm: 0,
            key: '',
            standardScan: '',
            chordSheet: '',
            spotifyUrl: ''
        }
    });
    const onSubmit = data => {
        // hook up to BE
        console.log(data);
    }

    return (
        <form onSubmit={handleSubmit(onSubmit)} className="form" id="new_song">
            <input type="hidden" name="authenticity_token" value={authenticityToken} autoComplete="off" />

            <Stack className="form-group" direction="column" spacing={2}>
                <Stack direction="row" spacing={3}>
                    <ReactHookFormTextField
                        name="name"
                        control={control}
                        rules={{
                            required: "Song title is required"
                        }}
                        error={!!errors.name}
                        errorMessage={errors.name?.message}
                        required={true}
                        label="Song Title"
                        type="text"
                    />

                    <ReactHookFormTextField
                        name="artist"
                        control={control}
                        label="Artist"
                        type="text"
                    />
                </Stack>
            </Stack>

            <div className="row">
                <div className="form-group col-md-4 required ">
                    <ReactHookFormSelect
                        name="tempo"
                        label="Tempo"
                        id="tempo"
                        control={control}
                        defaultValue={""}>
                        <MenuItem value="Fast">Fast</MenuItem>
                        <MenuItem value="Medium">Medium</MenuItem>
                        <MenuItem value="Slow">Slow</MenuItem>
                    </ReactHookFormSelect>
                    <FormHelperText>Select a tempo</FormHelperText>
                </div>
                <div className="form-group col-md-4 ">
                    <ReactHookFormTextField
                        name="bpm"
                        control={control}
                        rules={{
                            min: {
                                value: 1, message: 'BPM needs to be higher than 1'
                            },
                            max: {
                                value: 300, message: 'BPM needs to be lower than 300'
                            }
                        }}
                        label="bpm"
                        type="number"
                        error={!!errors.bpm}
                        errorMessage={errors.bpm?.message}
                    />
                </div>
                <div className="form-group col-md-4 required ">
                    <ReactHookFormSelect
                        name="key"
                        label="Key"
                        id="song_key"
                        control={control}
                        defaultValue={""}>
                        <MenuItem value="Ab">Ab</MenuItem>
                        <MenuItem value="A">A</MenuItem>
                        <MenuItem value="Bb">Bb</MenuItem>
                        <MenuItem value="C">C</MenuItem>
                        <MenuItem value="Db">Db</MenuItem>
                        <MenuItem value="D">D</MenuItem>
                        <MenuItem value="Eb">Eb</MenuItem>
                        <MenuItem value="E">E</MenuItem>
                        <MenuItem value="F">F</MenuItem>
                        <MenuItem value="F#">F#</MenuItem>
                        <MenuItem value="G">G</MenuItem>
                    </ReactHookFormSelect>
                    <FormHelperText>Choose key</FormHelperText>
                </div>
            </div>

            <div className="form-group">
                <ReactHookFormTextField
                    name="standardScan"
                    control={control}
                    label="Standard Scan"
                    helperText="e.g. V1. V2. PC. C. V3. V4."
                />
            </div>

            <div className="form-group required ">
                <ReactHookFormTextField
                    name="chordSheet"
                    control={control}
                    label="Chords"
                    rows={15}
                    multiline={true}
                />
            </div>

            <div className="form-group">
                <br />
                <i>Open Spotify &gt; Right Click On Song &gt; Share &gt; Hold Option/Alt &gt; Copy Spotify URI</i>
                <ReactHookFormTextField
                    name="spotifyUrl"
                    control={control}
                    rules={{
                        pattern: {
                            value: "spotify:track:.*",
                            message: "Spotify url needs to be in the format spotify:track:..."
                        }
                    }}
                    placeholder="e.g. spotify:track:6qdpQ6jPiaCYE9Qw4nZVuD"
                    error={!!errors.spotifyUrl}
                    errorMessage={errors.spotifyUrl?.message}
                />
            </div>
            <Button type="submit" variant="contained" size="large">Submit</Button>
        </form >
    )
}

export default UploadSongForm