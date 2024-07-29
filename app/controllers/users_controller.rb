class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      log_in @user
      redirect_to root_url
    else
      flash.now[:danger] = t "invalid_email_or_password"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit User::UPDATABLE_ATTRS
  end
end