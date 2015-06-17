class User < ActiveRecord::Base
  has_one :location, inverse_of: :user, dependent: :destroy
  has_one :payment, inverse_of: :user, dependent: :destroy
  has_many :user_roles, inverse_of: :user, dependent: :destroy
  has_many :roles, :through => :user_roles
  has_many :goals, inverse_of: :user, dependent: :destroy
  has_many :comments, inverse_of: :user, dependent: :destroy
  has_many :active_relationships, class_name:  'Relationship',
           foreign_key: 'follower_id',
           inverse_of: :follower,
           dependent:   :destroy
  has_many :passive_relationships, class_name:  'Relationship',
           foreign_key: 'followed_id',
           inverse_of: :followed,
           dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: Devise::email_regexp }
  validates :password, presence: true, confirmation: true, length: { in: 6..20 }, if: :password_required?
  validate :password_complexity

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :lockable

  def password_complexity
    if password.present? and not password.match(/^(?=.*[\d[!@#$%\^*()_\-=?|;:.,<>]])(?=.*[a-zA-Z])[a-zA-Z0-9!@#$%\^*()_\-=?|;:.,<>]*$/)
      errors.add :password, 'Invalid password. Passwords must be 6-20 characters and contain at least one letter and one number or special character.'
    end
  end

  def password_required?
    !password.nil? || !password_confirmation.nil?
  end

  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  def self.active
    joins(:payment).merge(Payment.active)
  end

  def active?
    payment.present? && payment.active?
  end

  def pending?
    payment.nil?
  end

  def canceled?
    payment.present? && payment.stripe_sub_token.blank?
  end

  def deactivated?
    payment.present? && payment.deactivated?
  end

  def follow(other_user)
    return if following?(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    return unless following?(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

end
