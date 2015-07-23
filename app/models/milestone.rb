class Milestone < ActiveRecord::Base
  belongs_to :goal, inverse_of: :milestones

  enum status: [ :open, :closed, :completed ] #DO NOT change this order

  validates :status, :title, :description, :reach_by_date, :goal, presence: true
  validates :title, length: { maximum: 80 }
  validates :description, length: { maximum: 400 }

end