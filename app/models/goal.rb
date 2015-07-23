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
  validate :two_active_goals_per_user

  private

  def two_active_goals_per_user
    if user.present? && status.present? && status == 'active'
      active_goal_count = Goal.where(user_id: user.id, status: Goal.statuses[:active]).count
      if active_goal_count == 2 && new_record?
        errors.add :base, 'You can only have two active goals at a time. Please complete or close an active goal before
                          starting a new one.'
      end
    end
  end

end