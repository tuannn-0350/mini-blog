class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :user_signed_in?, only: %i(create)
  skip_before_action :verify_authenticity_token, only: %i(create destroy)

  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase

    if user&.authenticate params.dig(:session, :password)
      log_in user
      render json: {data: {user: UserSerializer.new(user).serializable_hash}},
             status: :ok
    else
      render json: {errors: t("invalid_email_password_combination")},
             status: :unprocessable_entity
    end
  end

  def destroy
    if logged_in?
      log_out
      render json: {message: t("logged_out")}, status: :ok
    else
      render json: {errors: t("logged_out_failed")},
             status: :unprocessable_entity
    end
  end
end
