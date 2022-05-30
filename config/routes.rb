Rails.application.routes.draw do
  

  
  resources :users
  resources :tracks
  resources :playlists
  # Routing logic: fallback requests for React Router.
  # Leave this here to help deploy your app later!


    # Initially Authenticate User
    get '/authorized_user', to: 'users#show'

    # Login / Logout Routes
    post '/login', to: 'sessions#login'
    delete '/logout', to: 'sessions#logout'

    
  # get "*path", to: "fallback#index", constraints: ->(req) { !req.xhr? && req.format.html? }

  get "spotify_api/search", to: "spotify_api#search"

  get "spotify_api/audio-analysis", to: "spotify_api#audio_analysis"

  get "spotify_api/recommendations", to: "spotify_api#recommendations"

  get "spotify_api/connect", to: "spotify_api#connect"
  get "spotify_api/get_user_token", to: 'spotify_api#get_user_token'

  get "callback", to: "spotify_api#callback"

end
