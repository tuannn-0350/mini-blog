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
  scope :filter_by_title, lambda{|title|
                            where "title LIKE ?", "%#{title}%" if title.present?
                          }
  scope :filter_by_author, lambda{|author|
                             if author.present?
                               joins(:user).where "name LIKE ?", "%#{author}%"
                             end
                           }
  def update_status
    update status: !status
  end

  def self.import file, user
    spreadsheet = open_spreadsheet file
    header = %w(title body status)
    rows = []
    now = Time.zone.now

    (Settings.post.header_row + 1..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose].merge(
        created_at: now, updated_at: now
      )
      post = user.posts.build row
      return false, post, i unless post.valid?

      rows << row
    rescue StandardError
      return false, nil, i
    end
    user.posts.insert_all rows
    [true, nil, nil]
  end

  def self.open_spreadsheet file
    case File.extname(file.original_filename)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end
