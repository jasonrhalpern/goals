class Goal < ActiveRecord::Base
  belongs_to :user, inverse_of: :goals

  enum status: [ :active, :closed, :completed ] #DO NOT change this order

  validates :status, :title, :description, :user, presence: true
  validates :title, length: { maximum: 200 }
  validate :one_open_goal_per_user

  private

  def one_open_goal_per_user
    if user.present? && Goal.exists?(user_id: user.id, status: Goal.statuses[:active])
      errors.add :title, 'You can only have one active goal at a time. Please complete or close your active goal before
                            starting a new one.'
    end
  end

end