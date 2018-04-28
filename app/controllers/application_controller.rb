class ApplicationController < ActionController::API

  def authorized(token)
    @user = User.find_by(token: token)
  end

end
