class UsersController < ApplicationController
  before_action :find_user, only: %i(show)

  def index
    @users = User.order_by_name
    @pagy, @users = pagy @users, limit: Settings.pagy.items
  end

  def new
    @user = User.new
  end

  def show
    @pagy, @posts = pagy @user.posts.order_by_created_at,
                         limit: Settings.pagy.items
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

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "user_not_found"
    redirect_to root_url
  end
end
