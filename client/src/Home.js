import React, { useCallback } from 'react'

function Home() {
    const handleConnect = useCallback(() => {

        fetch('http://localhost:3000/spotify_api/connect', {headers: {
                'Content-Type': 'application/json',
            }}).then(res => res.json()).then(res => window.location = res.url)
    }, []);

    return (
        <>

            <div className=" bg-neutral-800 p-2 rounded-sm grid grid-rows-6">
                <h1 className="text-green-400 text-left font-semibold text-2xl leading-10">
                    <span className="text-3xl font-bold tracking-wider">Welcome to Remixer.</span> <br></br>
                    &nbsp;&bull; Search for a song to get started. <br></br>
                    &nbsp;&bull; Get additional information about the song such as tempo and key. <br></br>
                    &nbsp;&bull; Get recommendations for songs that share those similar parameters.<br></br>
                    &nbsp;&bull; Save songs into playlists ie: 116bpm F#minor.<br></br>
                    &nbsp;&bull; Create new playlists and update/delete existing playlists.</h1>
                <button
                    onClick={handleConnect}
                    className="
                      bg-neutral-600
                      text-green-300
                      px-3
                      py-1
                      rounded-sm
                      mx-1
                      hover:bg-green-700
                      active:bg-green-900
                      "
                >
                    Connect your Spotify Account
                </button>
            </div>
        </>
    )
}

export default Home