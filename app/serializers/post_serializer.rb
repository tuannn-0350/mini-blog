class PostSerializer < BaseSerializer
  attributes :id, :title, :body, :status, :created_at_format
  belongs_to :user, serializer: UserSerializer
  def created_at_format
    object.created_at.strftime("%D")
  end
end
