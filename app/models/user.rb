class User < ApplicationRecord
  UPDATABLE_ATTRS = %i(name email password password_confirmation).freeze

  before_save {email.downcase!}
  has_secure_password
  has_many :posts, dependent: :destroy

  has_many :active_relationships, class_name: Relationship.name,
foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :reactions, dependent: :destroy
  has_many :reacted_posts, through: :reactions, source: :post
end
