class Goal < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search,
                  :against => { :title => 'A', :description => 'B' },
                  :using => { :tsearch => { :prefix => true } }
  has_many :milestones, inverse_of: :goal, dependent: :destroy
  has_many :goal_tags, inverse_of: :goal, dependent: :destroy
  has_many :tags, :through => :goal_tags
  has_many :posts, inverse_of: :goal, dependent: :destroy
  belongs_to :user, inverse_of: :goals

  enum status: [ :active, :closed, :completed ] #DO NOT change this order
  enum visibility: [ :publiced, :privated ] #DO NOT change this order

  validates :title, :description, :status, :visibility, :type, :user, presence: true
  validates :title, length: { maximum: 80 }, uniqueness: { scope: :user_id }
  validates :description, length: { maximum: 800 } #should only be for FREE users
  validate :maximum_active_goals_per_user, :maximum_goal_tags

  scope :viewable, -> { where visibility: 'publiced' }

  private

  def maximum_active_goals_per_user
    if user.present? && status.present? && status == 'active'
      active_goals = Goal.where(user_id: user.id, status: Goal.statuses[:active])
      if active_goals.count == 3
        if new_record? || (!active_goals.map(&:id).include?(self.id))
          errors.add :base, 'You can only have three active goals at a time. Please complete or close an active goal before
                          starting a new one.'
        end
      end
    end
  end

  def maximum_goal_tags
    if self.goal_tags.count > 3
      errors.add :base, 'You can only add a maximum of 3 tags'
    end
  end

end