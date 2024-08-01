class Post < ApplicationRecord
  UPDATABLE_ATTRS = %i(title body status).freeze

  belongs_to :user
  has_many :reactions, dependent: :destroy
  has_many :reactors, through: :reactions, source: :user

  delegate :name, to: :user, prefix: true

  scope :published, ->{where status: true}
  scope :order_by_created_at, ->{order created_at: :desc}
end
