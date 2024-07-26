class Post < ApplicationRecord
  belongs_to :user
  has_many :reactions, dependent: :destroy
  has_many :reactors, through: :reactions, source: :user

  scope :order_by_created_at, ->{order created_at: :desc}
end
