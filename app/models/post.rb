class Post < ActiveRecord::Base
  belongs_to :goal, inverse_of: :posts
  has_many :comments, inverse_of: :post, dependent: :destroy

  validates :title, :content, :goal, presence: true
  validates :title, length: { maximum: 80 }
  validates :content, length: { maximum: 800 } #should only be for FREE users

end