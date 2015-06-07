class UserRole < ActiveRecord::Base
  belongs_to :user, inverse_of: :user_roles
  belongs_to :role, inverse_of: :user_roles

  validates :user_id, :role_id, presence: true
  validates :user_id, :uniqueness => { :scope => :role_id }
end