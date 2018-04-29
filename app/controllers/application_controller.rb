class ApplicationController < ActionController::API
  def authorized?(token)
    @user = User.find_by(token: token)
    if @user.nil?
      render json: { error: "Wrong authorization token!" }, status: :unauthorized
      return false
    end
    true
  end
end
