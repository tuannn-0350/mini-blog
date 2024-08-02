class ReactionsController < ApplicationController
  def create
    @post = Post.find_by id: params[:post_id]
    if @post.nil?
      flash[:danger] = t "post_not_found"
      redirect_to root_path
    else
      current_user.like @post
      respond_to do |format|
        format.html{redirect_to @post}
        format.turbo_stream
      end
    end
  end

  def destroy
    @post = Post.find_by id: params[:id]

    if @post.nil?
      flash[:danger] = t "post_not_found"
      redirect_to root_path
    else
      current_user.unlike @post
      respond_to do |format|
        format.html{redirect_to @post}
        format.turbo_stream
      end
    end
  end
end
