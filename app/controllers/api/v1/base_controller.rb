class Api::V1::BaseController < ApplicationController
  include Pagy::Backend
  rescue_from StandardError do |e|
    render json: {errors: e.message}, status: :internal_server_error
  end
  before_action :user_signed_in?

  private
  def user_signed_in?
    return if logged_in?

    render json: {errors: t("require_login")}, status: :unauthorized
  end
end
