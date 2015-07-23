class Goal < ActiveRecord::Base
  has_many :milestones, inverse_of: :goal, dependent: :destroy
  has_many :goal_tags, inverse_of: :goal, dependent: :destroy
  has_many :tags, :through => :goal_tags
  has_many :posts, inverse_of: :goal, dependent: :destroy
  belongs_to :user, inverse_of: :goals

  enum status: [ :active, :closed, :completed ] #DO NOT change this order
  enum visibility: [ :publiced, :privated ] #DO NOT change this order

  validates :title, :description, :status, :visibility, :user, presence: true
  validates :title, length: { maximum: 80 }, uniqueness: { scope: :user_id }
  validates :description, length: { maximum: 400 }, uniqueness: { scope: :user_id }
  validate :one_active_goal_per_user

  private

  def one_active_goal_per_user
    if user.present? && status.present? && status == 'active'
      active_goal = Goal.where(user_id: user.id, status: Goal.statuses[:active]).first
      if active_goal.present?
        if new_record? || active_goal.created_at != self.created_at
          errors.add :base, 'You can only have one active goal at a time. Please complete or close your active goal before
                              starting a new one.'
        end
      end
    end
  end

end