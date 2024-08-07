class Post < ApplicationRecord
  UPDATABLE_ATTRS = %i(title body status).freeze

  belongs_to :user
  has_many :reactions, dependent: :destroy
  has_many :reactors, through: :reactions, source: :user

  delegate :name, to: :user, prefix: true

  validates :title, presence: true,
length: {maximum: Settings.post.title_max_length}
  validates :body, presence: true,
length: {maximum: Settings.post.body_max_length}

  scope :published, ->{where status: true}
  scope :order_by_created_at, ->{order created_at: :desc}
  scope :feed, lambda {|following_ids|
    where(user_id: following_ids).order_by_created_at
  }

  def update_status
    update status: !status
  end
end
