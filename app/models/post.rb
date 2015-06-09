class Post < ActiveRecord::Base
  belongs_to :goal, inverse_of: :posts
  # has_many :comments, dependent: destroy

  validates :title, :content, :goal, presence: true
  validates :title, length: { maximum: 50 }

end