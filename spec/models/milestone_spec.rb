require 'rails_helper'

describe Milestone do

  it 'has a valid factory' do
    expect(build_stubbed(:milestone)).to be_valid
  end

  it 'is invalid without a status' do
    expect(build_stubbed(:milestone, status: nil)).to have(1).errors_on(:status)
  end

  it 'is invalid without a title' do
    expect(build_stubbed(:milestone, title: nil)).to have(1).errors_on(:title)
  end

  it 'is invalid with a title that is too long' do
    expect(build_stubbed(:milestone, title: 'heyyy' * 17)).to have(1).errors_on(:title)
  end

  it 'is invalid without a description' do
    expect(build_stubbed(:milestone, description: nil)).to have(1).errors_on(:description)
  end

  it 'is invalid with a description that is too long' do
    expect(build_stubbed(:milestone, description: 'heyy' * 201)).to have(1).errors_on(:description)
  end

  it 'is invalid without a reach by date' do
    expect(build_stubbed(:milestone, reach_by_date: nil)).to have(1).errors_on(:reach_by_date)
  end

  it 'is invalid without a goal' do
    expect(build_stubbed(:milestone, goal: nil)).to have(1).errors_on(:goal)
  end

end