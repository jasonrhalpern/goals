class Payment < ActiveRecord::Base
  belongs_to :user, inverse_of: :payment
  validates :stripe_cus_token, :active_until, :user_id, presence: true
  validates :stripe_sub_token, presence: true, if: :tokens_present?
  validates :user_id, :stripe_cus_token, :stripe_sub_token, uniqueness: true
  attr_accessor :stripe_card_token, :stripe_plan_token

  PAYMENT_EXCEPTIONS = [ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved, Stripe::CardError,
                        Stripe::InvalidRequestError, Stripe::AuthenticationError, Stripe::APIConnectionError,
                        Stripe::APIError, Stripe::StripeError].freeze

  scope :active, -> { where('active_until > ?', Time.now) }

  def save_with_plan
    return false unless tokens_present?
    set_active_until
    customer = Stripe::Customer.create(
        :email => user.email,
        :source  => stripe_card_token,
        :plan => stripe_plan_token,
        :description => 'Registered User'
    )
    self.stripe_cus_token = customer.id
    self.stripe_sub_token = customer.subscriptions.first.id
    save!
  rescue *PAYMENT_EXCEPTIONS => e
    logger.error "Stripe error while creating customer: #{e.message}"
    false
  end

  def get_card
    customer = retrieve_customer
    customer.sources.retrieve(customer.default_source)
  rescue *PAYMENT_EXCEPTIONS => e
    logger.error "Stripe error while retrieving customer: #{e.message}"
  end

  def get_plan
    return unless stripe_sub_token.present?
    customer = retrieve_customer
    subscription = customer.subscriptions.retrieve(stripe_sub_token)
    Plan.where(stripe_plan_token: subscription.plan.id).first
  rescue *PAYMENT_EXCEPTIONS => e
    logger.error "Stripe error while retrieving customer: #{e.message}"
  end

  def update_plan(plan_token)
    customer = retrieve_customer
    if stripe_sub_token.present?
      subscription = customer.subscriptions.retrieve(stripe_sub_token)
      subscription.plan = plan_token
      subscription.save
    else
      subscription = customer.subscriptions.create(:plan => plan_token)
      self.stripe_sub_token = subscription.id
      self.active_until = Time.now + self.class.update_buffer_time
      save!
    end
  rescue *PAYMENT_EXCEPTIONS => e
    logger.error "Stripe error while updating plan for customer: #{e.message}"
    false
  end

  def update_card(card_token)
    customer = retrieve_customer
    customer.sources.retrieve(customer.default_source).delete
    customer.source = card_token
    customer.save
    if deactivated?
      self.active_until = Time.now + self.class.update_buffer_time
      save
    end
    true
  rescue *PAYMENT_EXCEPTIONS => e
    logger.error "Stripe error while updating card for customer: #{e.message}"
    false
  end

  def cancel
    customer = retrieve_customer
    customer.subscriptions.retrieve(stripe_sub_token).delete
    self.stripe_sub_token = nil
    self.active_until = Time.now
    save!
  rescue *PAYMENT_EXCEPTIONS => e
    logger.error "Stripe error while canceling subscription: #{e.message}"
  end

  def deactivate
    self.active_until = Time.now
    save!
  rescue *PAYMENT_EXCEPTIONS => e
    logger.error "Error while deactivating account: #{e.message}"
  end

  def retrieve_customer
    Stripe::Customer.retrieve(stripe_cus_token)
  end

  def tokens_present?
    stripe_card_token.present? && stripe_plan_token.present?
  end

  def deactivated?
    stripe_sub_token.present? && (active_until < Time.now)
  end

  def active?
    stripe_sub_token.present? && (active_until > Time.now)
  end

  def set_active_until
    plan = Plan.where(stripe_plan_token: stripe_plan_token).first
    self.active_until = "#{plan.trial_days}".to_i.days.from_now + self.class.update_buffer_time
  end

  def extend_active_until(interval)
    self.active_until = (interval == 'year') ? 1.year.from_now : 1.month.from_now
    save!
  rescue *PAYMENT_EXCEPTIONS => e
    logger.error "Error while extending active until: #{e.message}"
  end

  def self.update_buffer_time
    2.hours
  end

end
