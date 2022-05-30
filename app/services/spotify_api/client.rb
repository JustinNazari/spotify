module SpotifyApi
    class Client 

        class << self
            attr_accessor :access_token
            
            [:get, :post].each do |action| 
                define_method(action) do |*args, &block|
                    if access_token.nil? 
                        @access_token = get_access_token
                    end
                    wrapped_connection(action, *args) { connection.public_send(action, *args, &block) }
                end
            end

            def wrapped_connection(action, *args)
                response = yield
                if response.success?
                    JSON.parse(response.body)
                else
                   @access_token = get_access_token
                   wrapped_connection(action, *args) { connection.public_send(action, *args) }
                end
            end

            # search by a track ID
            def get_track(id)
                get("tracks/#{id}")
            end

            #search by an artist ID
            def get_artist(id)
                get("artists/#{id}")
            end

            # get track analysis details
            def audio_analysis(id) 
                get("audio-analysis/#{id}")
            end

            # get multiple audio features (like analysis) 
            def audio_features(ids)
                get("audio-features?ids=#{ids}")
            end

            # get recommendation based off tempo and key with a range of +/- 5   %2C is a comma for inbetween genres ie: &seed_genres=pop%2Ctechno%2Cr-n-b
            # what happens if i take min and max tempo away and just use target_tempo? 
            def get_recommendations(id, tempo, key, mode) 
                get("recommendations?seed_tracks=#{id}&seed_genres=pop%2Cdance%2Cr-n-b%2Csoul&target_tempo=#{tempo.to_i}&min_tempo=#{tempo.to_i - 5}&max_tempo=#{tempo.to_i + 5}&min_key=#{key}&max_key=#{key}&min_mode=#{mode}&max_mode=#{mode}")
            end

            
            # search by a track name 
            def search_track(track_name)
                get("search?q=#{track_name}&type=track")
            end
            
            def credentials
                Base64.encode64(Rails.application.credentials.spotify[:client_id] + ':' + Rails.application.credentials.spotify[:client_secret]).delete("\n")
            end
            
            # base endpoint to then add custom endpoints to the end 
            def connection
                Faraday.new(url: 'https://api.spotify.com/v1', headers:{'Authorization' => "Bearer #{access_token}"})
            end

            def get_user_access_token(code:, redirect_uri:)
                response = Faraday.post('https://accounts.spotify.com/api/token', {code: code, redirect_uri: redirect_uri, grant_type: 'authorization_code'}, {
                  'Authorization' => "Basic #{credentials}", 'Content-Type' => 'application/x-www-form-urlencoded'
                })
                JSON.parse(response.body)
            end

            def get_access_token
                response = Faraday.post('https://accounts.spotify.com/api/token', {grant_type: 'client_credentials'}, {
                    'Authorization' => "Basic #{credentials}", 'Content-Type' => 'application/x-www-form-urlencoded'
                    })
                    JSON.parse(response.body).dig("access_token")
                end
            end
        end
    end
    
    
    
    # def available_genre_seeds
    #     get("recommendations/available-genre-seeds")
    # end
    
    # {"genres"=>["acoustic", "afrobeat", "alt-rock", "alternative", "ambient", "anime", "black-metal", "bluegrass", "blues", "bossanova",
    #      "brazil", "breakbeat", "british", "cantopop", "chicago-house", "children", "chill", "classical", "club", "comedy", "country",
    #       "dance", "dancehall", "death-metal", "deep-house", "detroit-techno", "disco", "disney", "drum-and-bass", "dub", "dubstep",
#        "edm", "electro", "electronic", "emo", "folk", "forro", "french", "funk", "garage", "german", "gospel", "goth", "grindcore",
#         "groove", "grunge", "guitar", "happy", "hard-rock", "hardcore", "hardstyle", "heavy-metal", "hip-hop", "holidays", "honky-tonk",
#          "house", "idm", "indian", "indie", "indie-pop", "industrial", "iranian", "j-dance", "j-idol", "j-pop", "j-rock", "jazz", "k-pop",
#           "kids", "latin", "latino", "malay", "mandopop", "metal", "metal-misc", "metalcore", "minimal-techno", "movies", "mpb", "new-age",
#            "new-release", "opera", "pagode", "party", "philippines-opm", "piano", "pop", "pop-film", "post-dubstep", "power-pop", "progressive-house",
#             "psych-rock", "punk", "punk-rock", "r-n-b", "rainy-day", "reggae", "reggaeton", "road-trip", "rock", "rock-n-roll", "rockabilly", "romance",
#              "sad", "salsa", "samba", "sertanejo", "show-tunes", "singer-songwriter", "ska", "sleep", "songwriter", "soul", "soundtracks", "spanish",
#               "study", "summer", "swedish", "synth-pop", "tango", "techno", "trance", "trip-hop", "turkish", "work-out", "world-music"]} 