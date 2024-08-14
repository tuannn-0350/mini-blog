class StaticPagesController < ApplicationController
  before_action :logged_in_user

  def index
    @pagy, @posts = pagy Post.published.order_by_created_at\
                             .filter_by_author(params[:user_name])\
                             .filter_by_title(params[:title]),
                         limit: Settings.pagy.items
  end
end
