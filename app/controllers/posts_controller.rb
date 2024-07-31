class PostsController < ApplicationController
  before_action :logged_in_user

  def index
    @posts = current_user.posts
    @pagy, @posts = pagy @posts.order_by_created_at, limit: Settings.pagy.items
  end

  def show
    @post = Post.find_by id: params[:id]
    return if @post

    flash[:danger] = t "post_not_found"
    redirect_to root_url
  end
end
