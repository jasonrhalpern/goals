require 'rails_helper'

describe Payment do
  let(:stripe_helper) { StripeMock.create_test_helper }
  before { StripeMock.start }
  after { StripeMock.stop }

  it 'has a valid factory' do
    expect(build_stubbed(:payment)).to be_valid
  end

  it 'is invalid without a stripe customer token' do
    expect(build_stubbed(:payment, stripe_cus_token: nil)).to have(1).errors_on(:stripe_cus_token)
  end

  it 'is invalid without a stripe subscription token if the card and plan tokens are present' do
    expect(build_stubbed(:payment, :stripe_plan_token => 'plan_1', :stripe_card_token => 'card_1',
                         stripe_sub_token: nil)).to have(1).errors_on(:stripe_sub_token)
  end

  it 'is valid without a stripe subscription token if either the card or plan tokens are not present' do
    expect(build_stubbed(:payment, :stripe_plan_token => 'plan_1', :stripe_card_token => nil,
                         stripe_sub_token: nil)).to be_valid
  end

  it 'is invalid without an active until time' do
    expect(build_stubbed(:payment, active_until: nil)).to have(1).errors_on(:active_until)
  end

  it 'is invalid without a user' do
    expect(build_stubbed(:payment, user: nil)).to have(1).errors_on(:user_id)
  end

  it 'is invalid without a unique user' do
    payment = create(:payment)
    expect(build_stubbed(:payment, user: payment.user)).to have(1).errors_on(:user_id)
  end

  it 'is invalid without a unique stripe customer token' do
    payment = create(:payment)
    expect(build_stubbed(:payment, stripe_cus_token: payment.stripe_cus_token)).to have(1).errors_on(:stripe_cus_token)
  end

  it 'is invalid without a unique stripe subscription token' do
    payment = create(:payment)
    expect(build_stubbed(:payment, stripe_sub_token: payment.stripe_sub_token)).to have(1).errors_on(:stripe_sub_token)
  end

  it 'sets the active until attribute based on the plan' do
    plan = create(:plan)
    payment = create(:payment, :stripe_plan_token => plan.stripe_plan_token)
    payment.set_active_until
    active_until = "#{plan.trial_days}".to_i.days.from_now + 6.hours
    expect(payment.active_until.to_date).to eq(active_until.to_date)
  end

  context 'Stripe' do
    before(:each) do
      @plan = stripe_helper.create_plan(:id => 'intro_plan', :interval => 'month', :amount => '395', :currency => 'usd',
                                        :trial_period_days => 30, :description => 'Deal Website Intro Plan')
      create(:plan, :stripe_plan_token => @plan.id, :description => @plan.name, :trial_days => @plan.trial_period_days,
             :interval => @plan.interval, :active => true)
    end

    it 'creates the Stripe customer and the payment plan' do
      payment = create(:payment, :stripe_plan_token => @plan.id, :stripe_card_token => stripe_helper.generate_card_token)
      expect(payment.save_with_plan).to be_truthy
    end

    # it 'returns the customer card details' do
    #   card_token = stripe_helper.generate_card_token(brand: 'Visa', last4: '9191', exp_month: 1, exp_year: 2018)
    #   customer = Stripe::Customer.create(email: 'h@aol.com', plan: @plan.id, source: card_token)
    #   payment = create(:payment, :stripe_cus_token => customer.id)
    #   card = payment.get_card
    #   expect(card.brand).to eq('Visa')
    #   expect(card.last4).to eq('9191')
    #   expect(card.exp_year).to eq(2018)
    #   expect(card.exp_month).to eq(1)
    # end
  end

  it 'returns an array of active payments' do
    deal1 = create(:payment, :active_until => 1.day.ago)
    deal2 = create(:payment, :active_until => 1.day.from_now)
    deal3 = create(:payment, :active_until => 1.month.from_now)
    expect(Payment.active).to eq([deal2, deal3])
  end

  describe '#extend_active_until' do
    it 'extends the active until date for a monthly plan' do
      monthly_plan = create(:plan, :interval => 'month')
      payment = create(:payment, :active_until => Time.now)

      payment.extend_active_until(monthly_plan.interval)
      active_until = 1.month.from_now
      expect(payment.active_until.to_date).to eq(active_until.to_date)
    end

    it 'extends the active until date for a yearly plan' do
      yearly_plan = create(:plan, :interval => 'year')
      payment = create(:payment, :active_until => Time.now)

      payment.extend_active_until(yearly_plan.interval)
      active_until = 1.year.from_now
      expect(payment.active_until.to_date).to eq(active_until.to_date)
    end
  end

  describe '#active?' do
    it 'returns true if the payment is active' do
      payment = build(:payment)
      expect(payment.active?).to be_truthy
    end

    it 'returns false if the payment is not active' do
      payment = build(:inactive_payment)
      expect(payment.active?).to be_falsey
    end
  end

  describe '#deactivated?' do
    it 'returns true if the payment is deactivated' do
      payment = build(:inactive_payment)
      expect(payment.deactivated?).to be_truthy
    end

    it 'returns false if the payment is active' do
      payment = build(:payment)
      expect(payment.deactivated?).to be_falsey
    end
  end

end