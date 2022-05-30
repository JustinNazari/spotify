class UsersController < ApplicationController
        before_action :authorize_user, except: [:create]

        def index 
            render json: User.all
        end
    
        def show
            # current_user = User.find_by(id: session[:current_user])
            current_user = User.first
            render json: current_user
        end
        
        def create 
            user = User.create!(user_params)
            render json: user, status: :created
        end
    
        def destroy 
            user = User.find(params[:id])
            user.destroy 
            head :no_content
        end
    
        def user_params 
            params.permit(:username, :email, :password)
        end
end
