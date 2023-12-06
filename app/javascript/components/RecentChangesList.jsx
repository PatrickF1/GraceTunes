import { Chip, Divider, Pagination, Stack } from '@mui/material'
import React, { useEffect, useState } from 'react'
import FilterButton from './FilterButton';
import CloseIcon from '@mui/icons-material/Close';
import AuditItem from './AuditItem';

function RecentChangesList() {
    const [page, setPage] = useState(1);
    const [activeFilter, setActiveFilter] = useState(null);
    const [data, setData] = useState([])
    const onChange = (e, pageNum) => {
        if (page !== pageNum) {
            console.log(pageNum);
            setPage(pageNum)
        }
    };

    const handleFilterClick = (filter) => {
        setActiveFilter(filter);
    };

    const auditItem = {
        audit_action: 'create',
        is_deleted: false,
        song_name: 'Test song',
        auditable_id: 1,
        audited_changes: [
            'test',
            'another test'
        ],
        created_at: '1998'
    }

    useEffect(() => {
        setData([auditItem, auditItem])
    }, [])

    return (
        <Stack direction="column" spacing={3}>
            <Stack direction="row" justifyContent="space-between" spacing={3}>
                <Pagination count={100} size="large" page={page} onChange={onChange} />
                <Stack direction="row" alignItems="center" spacing={2}>
                    <b>Filter by</b>
                    <FilterButton label="Updates" onClick={() => handleFilterClick('updates')} isActive={activeFilter === 'updates'} />
                    <FilterButton label="Creates" onClick={() => handleFilterClick('creates')} isActive={activeFilter === 'creates'} />
                    <FilterButton label="Deletes" onClick={() => handleFilterClick('deletes')} isActive={activeFilter === 'deletes'} />
                    {activeFilter && <Chip label="Clear" variant="outlined" color="error" icon={<CloseIcon />} onClick={() => handleFilterClick('')} />}
                </Stack>
            </Stack>
            {data.map(auditItem =>
                <>
                    <AuditItem item={auditItem} />
                    <Divider />
                </>
            )}

        </Stack>
    )
}

export default RecentChangesList