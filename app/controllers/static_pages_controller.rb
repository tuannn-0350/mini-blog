class StaticPagesController < ApplicationController
  def index
    @pagy, @posts = pagy(Post.order_by_created_at, items: Settings.pagy.items)
  end
end
