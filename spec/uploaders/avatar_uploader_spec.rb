require 'rails_helper'
require 'carrierwave/test/matchers'

describe 'avatar uploader' do
  include CarrierWave::Test::Matchers

  before(:each) do
    AvatarUploader.enable_processing = true
    @user = create(:user)
  end

  after(:each) do
    AvatarUploader.enable_processing = false
  end

  context "user avatar dimensions" do
    it "should have three versions" do
      expect(@user.avatar).to be_no_larger_than(400, 400)
      expect(@user.avatar.medium).to have_dimensions(200, 200)
      expect(@user.avatar.thumb).to have_dimensions(50, 50)
    end
  end

end