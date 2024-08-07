class Api::V1::PostsController < Api::V1::BaseController
  before_action :find_user_post, only: %i(publish)
  skip_before_action :verify_authenticity_token

  def create
    @post = current_user.posts.build post_params
    if @post.save
      render json: {data: {post: PostSerializer.new(@post).serializable_hash}},
             status: :ok
    else
      render json: {errors: @post.errors.full_messages},
             status: :unprocessable_entity
    end
  end

  def publish
    if @post.update_status
      handle_successful_publish @post
    else
      handle_failed_publish
    end
  end

  private

  def handle_failed_publish
    render json: {errors: t("post_update_failed")},
           status: :unprocessable_entity
  end

  def handle_successful_publish post
    render json: {status: post.status}, status: :ok
  end

  def post_params
    params.require(:post).permit Post::UPDATABLE_ATTRS
  end

  def find_user_post
    @post = current_user.posts.find_by id: params[:id]
    return if @post

    render json: {errors: t("post_not_found")}, status: :not_found
  end
end
