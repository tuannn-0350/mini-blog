class Post < ApplicationRecord
  belongs_to :user
  has_many :reactions, dependent: :destroy
  has_many :reactors, through: :reactions, source: :user

  delegate :name, to: :user, prefix: true

  scope :order_by_created_at, ->{order created_at: :desc}
end
