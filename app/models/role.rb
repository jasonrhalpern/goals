class Role < ActiveRecord::Base
  has_many :user_roles, inverse_of: :role
  has_many :users, :through => :user_roles

  validates :name, presence: true, uniqueness: true
end