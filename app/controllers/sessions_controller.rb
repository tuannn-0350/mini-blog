class SessionsController < ApplicationController
  before_action :logged_in_user, only: %i(destroy)

  def new; end

  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase

    if user&.authenticate params.dig(:session, :password)
      log_in user
      redirect_to root_url
    else
      flash.now[:danger] = t "invalid_email_password_combination"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to login_path
  end
end
