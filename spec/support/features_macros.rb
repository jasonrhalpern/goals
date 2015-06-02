require 'rails_helper'

module FeatureMacros
  include Warden::Test::Helpers

  def create_user
    user = create(:user)
    user.confirmed_at = Time.now
    user.save
    user
  end

  def login_user
    user = create_user
    login_as user, scope: :user
    user
  end

end