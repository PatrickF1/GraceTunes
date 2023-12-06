import React from 'react'
import RecentChangesList from '../components/RecentChangesList'

function HistoryPage() {
    return (
        <div className="container">
            <h1 className="page-header">Recent Changes</h1>

            <RecentChangesList />
        </div>
    )
}

export default HistoryPage