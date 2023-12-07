import { ExpandMore } from '@mui/icons-material'
import { Accordion, AccordionDetails, AccordionSummary, Box, Grid, Stack, Typography } from '@mui/material'
import React from 'react'
import { Link } from 'react-router-dom'

function AuditItem({ item }) {
    let containerStyle = '';
    if (item.audit_action == 'create') {
        containerStyle = 'bg-success'
    } else if (item.audit_action == 'update') {
        containerStyle = 'bg-warning'
    } else if (item.audit_action == 'destroy') {
        containerStyle = 'bg-danger'
    }
    return (
        <Box sx={{ padding: "15px" }} className={containerStyle}>
            <h4>
                <strong>
                    {item.is_deleted
                        ? <del>item.song_name</del>
                        : <Link to={`/songs/${item.auditable_id}`}>{item.song_name}</Link>}
                </strong>
            </h4>
            <h5>by <strong>USER</strong></h5>
            <h5>on <span className="audit-created-at">{item.created_at}</span></h5>
            <br />

            {item.audited_changes.map((change, index) =>
                <Accordion key={index} className="panel panel-default">
                    <AccordionSummary
                        className="panel-heading"
                        expandIcon={<ExpandMore />}
                        aria-controls={`panel${index}-content`}
                        id={`panel${index}-header`}
                    >
                        <h4 className="panel-title">
                            TITLE
                        </h4>
                    </AccordionSummary>
                    <AccordionDetails>
                        <Grid container spacing={0}>
                            <Grid item xs={6}>
                                <h4>Before</h4>
                                <hr />
                                <div className="diff">
                                    <ul>
                                        <li className="del">
                                            del
                                        </li>
                                    </ul>
                                </div>
                            </Grid>
                            <Grid item xs={6}>
                                <h4>After</h4>
                                <hr />
                                <div className="diff">
                                    <ul>
                                        <li className="in">
                                            in
                                        </li>
                                    </ul>
                                </div>
                            </Grid>
                        </Grid>
                    </AccordionDetails>
                </Accordion>
            )}

        </Box>

    )
}

export default AuditItem