module UsersHelper
  def load_following
    current_user.active_relationships.find_by followed_id: @user.id
  end

  def load_reacted
    current_user.reactions.find_by post_id: @post.id
  end
end
