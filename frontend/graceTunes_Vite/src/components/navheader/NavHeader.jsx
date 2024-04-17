import "./NavHeader.css"
import { Link } from "react-router-dom"
import Profile from "../profile/Profile"

function NavHeader() {
  return (
    <>
      <nav className="navHeader">
        <div>GRACETUNES</div>
        <ul className="navLinks">
          <li>
            <Link className="hover-underline-animation" to="/about">
              ABOUT
            </Link>
          </li>
          <li>
            <Link className="hover-underline-animation" to="/search">
              SEARCH
            </Link>
          </li>
          <li>
            <Link className="hover-underline-animation" to="/changes">
              RECENT CHANGES
            </Link>
          </li>
          <li>
            <Link className="hover-underline-animation" to="/upload">
              UPLOAD SONG
            </Link>
          </li>
          <li>
            <Link className="hover-underline-animation" to="/request">
              REQUEST SONG
            </Link>
          </li>
        </ul>
        <div className="profileSection">
          <Profile />
        </div>
      </nav>
    </>
  )
}

export default NavHeader
