class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  include ActionController::Cookies

  def current_user
    User.first
    # User.find_by(id: session[:current_user])
  end

  def authorize_user
    return render json: { error: "Not Authorized" }, status: :unauthorized unless current_user
  end
  
  
  private 
  
  def render_unprocessable_entity_response(invalid)
    render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
  end
  
  def render_not_found_response(invalid)
    render json: {error: "#{invalid.model} not found"}, status: :not_found
  end
end


# THIS IS JWT STUFF-----------------------------------------------------------------------------------------
# before_action :authorize
#   def authorize 
#     # eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.Mz1IBGdftGI29M9wbuJKFUQwJc9nRkMCDC6BpVaNZhw token examp
#     auth_header = request.headers[:Authorization]

#     if !auth_header
#         render json: { message: 'Must send token in request.' }, status: :forbidden
#     else 
#         token = auth_header.split(' ')[1]
#         secret = 'secret'

#     begin
#         decoded_token = JWT.decode token, secret
#         payload = decoded_token.first
#         user_id = payload['user_id']
#         @user = User.find user_id
#     rescue
#         render json: { message: 'Invalid token' }, status: :forbidden
#     end
#   end
# end