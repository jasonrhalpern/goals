require 'rails_helper'

describe Plan do

  it 'has a valid factory' do
    expect(build_stubbed(:plan)).to be_valid
  end

  it 'is invalid without a stripe plan token' do
    expect(build_stubbed(:plan, stripe_plan_token: nil)).to have(1).errors_on(:stripe_plan_token)
  end

  it 'is invalid without a description' do
    expect(build_stubbed(:plan, description: nil)).to have(1).errors_on(:description)
  end

  it 'is invalid without trial days' do
    expect(build_stubbed(:plan, trial_days: nil)).to have(1).errors_on(:trial_days)
  end

  it 'is invalid without an interval' do
    expect(build_stubbed(:plan, interval: nil)).to have(2).errors_on(:interval)
  end

  it 'is invalid without an active flag' do
    expect(build_stubbed(:plan, active: nil)).to have(1).errors_on(:active)
  end

  it 'is invalid without a unique stripe plan token' do
    plan = create(:plan)
    expect(build_stubbed(:plan, stripe_plan_token: plan.stripe_plan_token)).to have(1).errors_on(:stripe_plan_token)
  end

  it 'is invalid if the interval is not included in the list of options' do
    expect(build_stubbed(:plan, interval: 'day')).to have(1).errors_on(:interval)
  end

  it 'returns an array of active plans' do
    deal1 = create(:plan, :active => false)
    deal2 = create(:plan)
    deal3 = create(:plan)
    expect(Plan.active).to eq([deal2, deal3])
  end

  it 'returns an array of plans with no free trial' do
    deal1 = create(:plan, :trial_days => 0)
    deal2 = create(:plan)
    deal3 = create(:plan, :trial_days => 0)
    expect(Plan.no_free_trial).to eq([deal1, deal3])
  end

  it 'returns an array of plans with a free trial' do
    deal1 = create(:plan, :trial_days => 0)
    deal2 = create(:plan)
    deal3 = create(:plan)
    expect(Plan.free_trial).to eq([deal2, deal3])
  end

end