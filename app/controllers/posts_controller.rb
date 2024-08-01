class PostsController < ApplicationController
  before_action :logged_in_user
  before_action :find_user_post, only: %i(edit update destroy)

  def index
    @posts = current_user.posts
    @pagy, @posts = pagy @posts.order_by_created_at, limit: Settings.pagy.items
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build post_params
    if @post.save
      flash[:success] = t "post_created"
      redirect_to user_posts_path(current_user)
    else
      flash.now[:danger] = t "post_create_failed"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find_by id: params[:id]
    return if @post

    flash[:danger] = t "post_not_found"
    redirect_to root_url
  end

  def edit;  end

  def update
    if @post.update post_params
      flash[:success] = t "post_updated"
    else
      flash[:danger] = t "post_update_failed"
    end
    redirect_to user_posts_path(current_user)
  end

  def destroy
    if @post.destroy
      flash[:success] = t "post_deleted"
    else
      flash[:danger] = t "post_delete_failed"
    end

    redirect_to user_posts_path(current_user)
  end

  private

  def post_params
    params.require(:post).permit Post::UPDATABLE_ATTRS
  end

  def find_user_post
    @post = current_user.posts.find_by id: params[:id]
    return if @post

    flash[:danger] = t "post_not_found"
    redirect_to user_posts_path(current_user)
  end
end
