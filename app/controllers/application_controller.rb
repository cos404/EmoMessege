class ApplicationController < ActionController::API

  def authorized?(token)
    @user = User.find_by(token: token)
    if !@user
      render status: :unauthorized
      return false
    end
    return true
  end

end
