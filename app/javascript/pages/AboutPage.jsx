import React from 'react'

const ABOUT_PAGE_URL = 'https://docs.google.com/document/d/e/2PACX-1vS086ZBTQU-hG5q36mUUBm8oGEgIjoZEP7w2JuyHFS9hDIAJ8WODNHVomcBJI5rZLyhukYMVrL1atjA/pub';

function AboutPage() {
    return (
        <div className="general">
            <iframe src={ABOUT_PAGE_URL} />
        </div>
    )
}

export default AboutPage