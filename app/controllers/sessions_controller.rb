class SessionsController < ApplicationController
    # Sessions controller is being managed by bcrypt and we are customizing how to verify our users
    # When a user is logged in... as long as they stay logged in... THAT is a session

    before_action :authorize_user, except: [:login]

    def login
        user = User.find_by(username: params[:username])
        
        # same as if user && user.authenticate
        if user&.authenticate(params[:password])

            session[:current_user] = user.id
            render json: user, status: :ok
        else            
            # - Set Session's 'login_attempts' to 0 if Undefined / Falsey
            session[:login_attempts] ||= 0

            # - Increment Session's 'login_attempts' by 1
            session[:login_attempts] += 1

            render json: { error: "Invalid Password and/or Username" },  status: :unauthorized
        end
    end 

    def logout
        session.delete :current_user
    end 
end


