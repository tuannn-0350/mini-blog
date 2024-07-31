class ApplicationController < ActionController::Base
  include Pagy::Backend
  include SessionsHelper

  rescue_from ::ActiveRecord::RecordNotFound, with: :record_not_found

  before_action :set_locale
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  private
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "please_log_in"
    redirect_to login_url
  end

  def record_not_found
    flash[:danger] = t "record_not_found"
    redirect_to root_url
  end
end
