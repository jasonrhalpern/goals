class Post < ActiveRecord::Base
  belongs_to :goal, inverse_of: :posts
  has_many :comments, inverse_of: :post, dependent: :destroy

  validates :title, :content, :goal, presence: true
  validates :title, length: { maximum: 50 }
  validates :content, length: { maximum: 400 }

end