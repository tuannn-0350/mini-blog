class Api::V1::RelationshipsController < Api::V1::BaseController
  before_action :find_user
  skip_before_action :verify_authenticity_token

  def create
    unless current_user.can_follow? @user
      render json: {errors: t("cannot_follow_yourself")},
             status: :unprocessable_entity
      return
    end

    current_user.follow @user
    render json: {follower: user_serializer(current_user),
                  followed: user_serializer(@user),
                  message: t("follow")},
           status: :ok
  end

  def destroy
    if current_user.following? @user
      current_user.unfollow @user
      render json: {follower: user_serializer(current_user),
                    followed: user_serializer(@user),
                    message: t("unfollow")},
             status: :ok
    else
      render json: {errors: t("not_followed")}, status: :unprocessable_entity
    end
  end

  private
  def find_user
    @user = User.find_by id: params[:followed_id]
    return if @user

    render json: {errors: t("user_not_found")}, status: :not_found
  end

  def user_serializer user
    UserSerializer.new(user).serializable_hash
  end
end
