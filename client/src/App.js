import {useState, useEffect} from 'react';
import { BrowserRouter as Router, Routes, Route } from "react-router-dom"

import Navigation from './Navigation';
import Home from './Home';
import Search from './Search';
import Success from './Success';
import Playlists from './Playlists';
import Login from './Login';


function App() {

  const playlistsURL = "http://localhost:3000/playlists"
  const [playlists, setPlaylists] = useState([]);

  const [isAuthenticated, setIsAuthenticated] = useState(false); 
  const [user, setUser] = useState(null);

  useEffect(() => {
    fetch(`http://localhost:3000/authorized_user`)
    .then((res) => {
      if (res.ok) {
        res.json()
        .then((user) => {
          setIsAuthenticated(true);
          setUser(user);
        });
      }
    });
    fetch(playlistsURL)
    .then(res => res.json())
    .then(setPlaylists)

  },[])

 // Reroute user to <Login /> Component if not authenticated
 if (!isAuthenticated) return <Login error={'please login'} setIsAuthenticated={setIsAuthenticated} setUser={setUser} />;

  return (
    <div className="p-1 text-center grid gap-1">
      <Router>
        <Navigation />
        <Routes>
          <Route path="/login" element={<Login setUser={setUser} setIsAuthenticated={setIsAuthenticated}/>}/>
          <Route path="/" element={<Home />}/>
          <Route path="/success" element={<Success />}/>
          <Route path="/search" element={<Search playlists={playlists} setPlaylists={setPlaylists}/>}/>
          <Route path="/playlists" element={<Playlists playlists={playlists}/>}/>
        </Routes>
      </Router>
    </div>
  );
}

export default App;
