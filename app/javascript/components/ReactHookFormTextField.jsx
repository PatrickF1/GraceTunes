import React from 'react'
import { Controller } from 'react-hook-form'
import { TextField } from '@mui/material'

function ReactHookFormTextField({
    name,
    label,
    control,
    rules,
    defaultValue,
    error,
    errorMessage,
    helperText,
    required,
    type,
    ...props
}) {
    return (
        <Controller
            name={name}
            control={control}
            rules={rules}
            render={({ field }) =>
                <TextField
                    {...props}
                    {...field}
                    type={type}
                    fullWidth
                    label={label}
                    error={error}
                    helperText={errorMessage ? errorMessage : helperText}
                    required={required}
                />}
        />
    )
}

export default ReactHookFormTextField