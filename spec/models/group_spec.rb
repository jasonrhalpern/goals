require 'rails_helper'

describe Group do

  it 'has a valid factory' do
    expect(build_stubbed(:group)).to be_valid
  end

  it 'is invalid without a name' do
    expect(build_stubbed(:group, name: nil)).to have(1).errors_on(:name)
  end

  it 'is invalid without a user' do
    expect(build_stubbed(:group, user: nil)).to have(1).errors_on(:user)
  end

end