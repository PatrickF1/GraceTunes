import React from 'react';
import Chip from '@mui/material/Chip';

const FilterButton = ({ label, onClick, isActive }) => {

    return (
        <Chip
            label={label}
            variant={isActive ? 'default' : 'outlined'}
            onClick={onClick}
            color='primary'
        />
    );
};

export default FilterButton;