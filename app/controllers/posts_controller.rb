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

  def edit; end

  def update
    if @post.update post_params
      flash[:success] = t "post_updated"
      redirect_to user_posts_path(current_user)
    else
      flash[:danger] = t "post_update_failed"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @post.destroy
      flash[:success] = t "post_deleted"
    else
      flash[:danger] = t "post_delete_failed"
    end

    redirect_to user_posts_path(current_user)
  end

  def feed
    @pagy, @posts = pagy Post.published.feed(current_user.following_ids)\
                             .order_by_created_at\
                             .filter_by_author(params[:user_name])\
                             .filter_by_title(params[:title]),
                         limit: Settings.pagy.items
  end

  def export
    @posts = Post.published.order_by_created_at\
                 .filter_by_author(params[:user_name])\
                 .filter_by_title(params[:title])
    respond_to do |format|
      format.html
      format.xlsx do
        response.headers["Content-Disposition"] =
          "attachment; filename=posts.xlsx"
      end
    end
  end

  def import
    if params[:file].blank?
      flash[:danger] = t "import_failed"

    else
      success, row = Post.import params[:file], current_user
      if success
        handle_import_success
      else
        handle_import_error row
      end
    end
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

  def handle_import_error row
    flash[:danger] = t("import_failed_at_row", row:)
    redirect_to user_posts_path(current_user)
  end

  def handle_import_success
    flash[:success] = t "import_success"
    redirect_to user_posts_path(current_user)
  end
end
