class Group < ActiveRecord::Base
  has_many :goals, inverse_of: :group, dependent: :destroy
  belongs_to :user, inverse_of: :groups

  validates :name, :user, presence: true

end