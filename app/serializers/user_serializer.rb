class UserSerializer < BaseSerializer
  attributes :name, :email

  USER_INFO = %i(name email created_at updated_at).freeze
end
