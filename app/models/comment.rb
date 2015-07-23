class Comment < ActiveRecord::Base
  belongs_to :post, inverse_of: :comments
  belongs_to :user, inverse_of: :comments

  validates :content, :post, :user, presence: true
  validates :content, length: { maximum: 300 }

  delegate :username, to: :user
end