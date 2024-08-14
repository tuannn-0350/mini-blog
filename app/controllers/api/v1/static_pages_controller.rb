class Api::V1::StaticPagesController < Api::V1::BaseController
  def index
    @pagy, @posts = pagy Post.published.order_by_created_at\
                             .filter_by_author(params[:user_name])\
                             .filter_by_title(params[:title]),
                         limit: Settings.pagy.items
    render json: {data: {posts: @posts, each_serializer: PostSerializer}},
           status: :ok
  end
end
