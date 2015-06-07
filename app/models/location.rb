class Location < ActiveRecord::Base
  geocoded_by :address
  belongs_to :user, inverse_of: :location

  validates :address_line_1, :country, :user, presence: true
  validates :user_id, uniqueness: true
  validate :city_or_state?

  after_validation :geocode

  private

  def address
    [address_line_1, address_line_2, city, state, country, zip_code].compact.join(', ')
  end

  def city_or_state?
    if city.nil? && state.nil?
      errors.add :city, 'You must enter a City/Town or State/Province/Region'
      errors.add :state
    end
  end

end