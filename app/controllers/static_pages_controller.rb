class StaticPagesController < ApplicationController
  before_action :logged_in_user

  def index
    @pagy, @posts = pagy Post.order_by_created_at, limit: Settings.pagy.items
  end
end
