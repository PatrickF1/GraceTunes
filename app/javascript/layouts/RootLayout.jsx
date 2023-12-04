import React from 'react'
import { NavLink, Outlet } from 'react-router-dom'

function RootLayout() {
    return (
        <div className="gracetunes">
            <header className="header-container">
                <nav className="header">
                    <NavLink to="/" className="header_logo">Grace<span className="header_logo-emphasized">Tunes</span></NavLink>

                    <div className="header_links">
                        <div className="header_link">
                            <NavLink to="/about"><i className="fa fa-book" />About</NavLink>
                        </div>
                        <div className="header_link">
                            <NavLink to="/songs" className="header_link"><i className="fa fa-search" />Search</NavLink>
                        </div>
                        <div className="header_link">
                            <NavLink to="/history" className="header_link"><i className="fa fa-history" />Recent Changes</NavLink>
                        </div>
                        <div className="header_link">
                            <NavLink to="/songs/new" className="header_link"><i className="fa fa-music" />Upload Song</NavLink>
                        </div>
                        <div className="header_link">
                            <NavLink to="/request-song" className="header_link"><i className="fa fa-music" />Request Song</NavLink>
                        </div>
                    </div>

                    <div className="header_user">
                        <a href="/signout" className="pill pill_link-red">Sign Out</a>
                    </div>
                </nav>
            </header>
            <main>
                <Outlet />
            </main>
        </div>
    )
}

export default RootLayout