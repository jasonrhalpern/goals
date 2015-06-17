class Relationship < ActiveRecord::Base
  belongs_to :followed, class_name: 'User', inverse_of: :passive_relationships, counter_cache: :followers_count
  belongs_to :follower, class_name: 'User', inverse_of: :active_relationships, counter_cache: :following_count

  validates :followed, :follower, presence: true
  validates :followed_id, uniqueness: { scope: :follower_id }
end
