import "./NavBar.css"
import { Link } from "react-router-dom"
import Profile from "../profile/Profile"
import GTLogo from "../logo/GTLogo"

function NavBar() {
  return (
    <>
      <nav className="navHeader">
        <div className="nav-bar-left">
          <div className="gt-logo">
            <GTLogo />
          </div>
          <ul className="navLinks">
            <li>
              <Link className="hover-underline-animation" to="/about">
                ABOUT
              </Link>
            </li>
            <li>
              <Link className="hover-underline-animation" to="/songs">
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
        </div>
        <div className="profileSection">
          <Profile />
        </div>
      </nav>
    </>
  )
}

export default NavBar
