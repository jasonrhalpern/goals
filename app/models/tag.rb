class Tag < ActiveRecord::Base
  has_many :goal_tags, inverse_of: :tag, dependent: :destroy
  has_many :goals, :through => :goal_tags

  validates :name, presence: true, uniqueness: true
end