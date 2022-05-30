class SpotifyApiController < ApplicationController

    def connect
        client_id = Rails.application.credentials.spotify[:client_id]
        response_type = 'code'
        redirect_uri = 'http://localhost:3000/callback'
        scope = 'streaming playlist-modify-public user-library-modify user-library-read playlist-read-private playlist-modify-private'
        url = "https://accounts.spotify.com/authorize?client_id=#{client_id}&redirect_uri=#{redirect_uri}&scope=#{scope}&response_type=#{response_type}"
        # binding.pry
        render json: { url: url }, status: :ok
    end

    def callback
        binding.pry
        current_user = User.find session[:current_user]
    end

    def search
        binding.pry
        results = SpotifyApi::Client.search_track(params[:track_name])
        
        first_track = results.dig('tracks', 'items', 0)
        
        audio_analysis_for_first_track = SpotifyApi::Client.audio_analysis(first_track.dig('id'))
        
        first_track['audio_analysis'] = audio_analysis_for_first_track.dig('track')

        get_artist_for_first_track = SpotifyApi::Client.get_artist(first_track.dig('artists', 0, 'id'))

        first_track['genres'] = get_artist_for_first_track.dig('genres')

        render json: first_track, status: :ok
    end

    def audio_analysis 
        results = SpotifyApi::Client.audio_analysis(params[:id])
        render json: results, status: :ok
    end

    def recommendations
        results = SpotifyApi::Client.get_recommendations(params[:id], params[:tempo], params[:key], params[:mode]).dig('tracks')

        ids = results.map do |track| 
            track.dig('id') 
        end

        audio_features_for_results = SpotifyApi::Client.audio_features(ids.join(",")).dig('audio_features')

        results.each do |track| 
            track['audio_features'] = audio_features_for_results.find do |features|
             features.dig('id') == track.dig('id')
            end
        end

        # results.each do |track, index| (this assumes that the index positions are identical in both... not as safe as matching id's)
        #     track['audio_features'] = audio_features_for_results[index]
        # end

        render json: results, status: :ok
    end
end


