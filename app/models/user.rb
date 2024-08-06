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

  validates :name, presence: true,
                   length: {maximum: Settings.user.name_max_length,
                            minimum: Settings.user.name_min_length}

  validates :email, presence: true,
                    length: {maximum: Settings.user.email_max_length,
                             minimum: Settings.user.email_min_length},
                    format: {with: Settings.user.email_regex},
                    uniqueness: {case_sensitive: false}

  validates :password, presence: true,
                       length: {minimum: Settings.user.password_min_length,
                                maximum: Settings.user.password_max_length}

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

  def like? post
    reacted_posts.include? post
  end

  def like post
    reactions << Reaction.new(post:)
  end

  def unlike post
    reaction = reactions.find_by id: post.id
    reactions.delete reaction
  end

  private

  def downcase_email
    email.downcase!
  end
end
