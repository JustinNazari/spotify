import SpotifyPlayer from 'react-spotify-web-playback';

import {useEffect, useState} from "react";

function Result({ currentTrack, handleRecommendation, playlists, selectedPlaylist, setSelectedPlaylist, handleSaveTrack }) {

  const millisToMinutesAndSeconds = (millis) => {
    const minutes = Math.floor(millis / 60000);
    const seconds = ((millis % 60000) / 1000).toFixed(0);
    return `${minutes}:${seconds < 10 ? "0" : ""}${seconds}`;
  };

  const keyToNotes = (key) => {
    const notes = ["C", "C#/Db", "D", "D#/Eb", "E", "F", "F#/Gb", "G", "G#/Ab", "A", "A#/Bb", "B"]
    return key >=0 ? notes[key] : "No key detected"
  }

  const modeToWord = (num) => {
    return num > 0 ? "Major" : "Minor"
  }

  const [userToken, setUserToken] = useState()

  useEffect(() => {
    fetch(`http://localhost:3000/spotify_api/get_user_token`)
        .then((res) => {
          if (res.ok) {
            res.json()
                .then((res) => {
                  setUserToken(res.token);
                });
          }
        });
  },[])

  return (
    <div>
      {userToken && currentTrack && <SpotifyPlayer
          token={userToken}
          uris={[currentTrack.uri]}
      />}
        <div className="text-green-200 text-xs font-medium leading-[19px] p-1 mx-auto flex items-left text-left justify-center">
          <img
            className=" mr-3 h-[170px]"
            src={currentTrack.album.images[1].url}
            alt="album cover"
          ></img>
          <div>
            <span className="text-green-400 font-semibold tracking-wide">
              TRACK NAME: &nbsp;
            </span>
            {currentTrack.name} <br></br>

            <span className="text-green-400 font-semibold tracking-wide">
              TRACK DURATION: &nbsp;
            </span>
            {millisToMinutesAndSeconds(currentTrack.duration_ms)} <br></br>

            <span className="text-green-400 font-semibold tracking-wide">
              ARTIST NAME: &nbsp;
            </span>
            {currentTrack.artists[0].name} <br></br>
            <span className="text-green-400 font-semibold tracking-wide">
              ALBUM NAME: &nbsp;
            </span>
            {currentTrack.album.name} <br></br>
            <span className="text-green-400 font-semibold tracking-wide">
              ANALYSIS TEMPO: &nbsp;
            </span>
            {Math.round(currentTrack.audio_analysis.tempo)} &nbsp;&nbsp;<span className="text-green-400 font-semibold tracking-wide">
              TIME SIGNATURE:&nbsp;
            </span> {currentTrack.audio_analysis.time_signature}/4 <br></br>
            <span className="text-green-400 font-semibold tracking-wide">
              ANALYSIS KEY: &nbsp;
            </span>
            {keyToNotes(currentTrack.audio_analysis.key)} &nbsp;&nbsp;<span className="text-green-400 font-semibold tracking-wide">
              MODE:&nbsp;
            </span>
            {modeToWord(currentTrack.audio_analysis.mode)} &nbsp;&nbsp; <br></br>
            
            <span className="text-green-400 font-semibold tracking-wide">
              GENRES:&nbsp;
            </span>{currentTrack.genres.map(g => `${g} / `)}


            <br></br>
            <div className="flex">
            <button
              onClick={handleRecommendation}
              className="     
            bg-neutral-600
            text-green-300 
              text-base
              px-4
              py-0.5
              rounded-sm
              my-1
            hover:bg-green-700
            active:bg-green-900
            "
            >
              Get Recommendations
            </button>

            <form>
            <select className="
              text-center
            bg-neutral-600
            text-green-300 
              text-base
              px-1
              py-[3.3px]
              rounded-sm
              my-1
              ml-2"
              value={selectedPlaylist}
              onChange={(e) => setSelectedPlaylist(e.target.value)}
              >
                <option value="">Select Playlist</option>
                {playlists.map((playlist) => (
                  <option key={playlist.id} value={playlist.id}>
                    {playlist.name}
                  </option>
                ))}
            </select>
            {selectedPlaylist && <button
              onClick={handleSaveTrack}
              className="     
            bg-neutral-600
            text-green-300 
              text-base
              px-4
              py-0.5
              rounded-sm
              my-1
              ml-2
            hover:bg-green-700
            active:bg-green-900
            "
            >
              Save To Playlist
            </button>}
            </form>
            </div>
          </div>
        </div>
    </div>
  );
}

export default Result;
