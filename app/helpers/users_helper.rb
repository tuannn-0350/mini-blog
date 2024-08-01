module UsersHelper
  def load_following
    current_user.active_relationships.find_by followed_id: @user.id
  end
end
