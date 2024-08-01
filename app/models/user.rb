class User < ApplicationRecord
  UPDATABLE_ATTRS = %i(name email password password_confirmation).freeze

  before_save :downcase_email
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

  scope :order_by_name, ->{order name: :asc}

  def follow other_user
    following << other_user
  end

  def unfollow other_user
    following.delete other_user
  end

  def following? other_user
    following.include? other_user
  end

  private

  def downcase_email
    email.downcase!
  end
end
