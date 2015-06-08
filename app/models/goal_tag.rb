class GoalTag < ActiveRecord::Base
  belongs_to :goal, inverse_of: :goal_tags
  belongs_to :tag, inverse_of: :goal_tags

  validates :goal_id, :tag_id, presence: true
  validates :tag_id, :uniqueness => { :scope => :goal_id }
end