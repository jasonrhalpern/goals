require 'rails_helper'

describe Location do

  it 'has a valid factory' do
    expect(build_stubbed(:location)).to be_valid
  end

  it 'is invalid without an address' do
    expect(build_stubbed(:location, address: nil)).to have(1).errors_on(:address)
  end

  it 'is invalid without a city or state' do
    expect(build_stubbed(:location, city: nil, state: nil)).to have(1).errors_on(:city)
  end

  it 'is valid with no state if it has a city' do
    expect(build_stubbed(:location, state: nil, city: 'NY')).to be_valid
  end

  it 'is valid with no city if it has a state' do
    expect(build_stubbed(:location, city: nil, state: 'NY')).to be_valid
  end

  it 'is invalid without a user' do
    expect(build_stubbed(:location, user: nil)).to have(1).errors_on(:user)
  end

  it 'is invalid if the user is not unique' do
    location = create(:location)
    expect(build_stubbed(:location, user: location.user)).to have(1).errors_on(:user_id)
  end

end