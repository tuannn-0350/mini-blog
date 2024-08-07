class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :status, :created_at, :updated_at, :user_id,
             :user_name
end
