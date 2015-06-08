class Tag < ActiveRecord::Base
  has_many :goal_tags, inverse_of: :tag
  has_many :goals, :through => :goal_tags

  validates :name, presence: true, uniqueness: true
end