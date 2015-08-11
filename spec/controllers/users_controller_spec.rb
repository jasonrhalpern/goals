require 'rails_helper'

describe UsersController do
  login_user

  describe "GET #followings" do
    it "populates an array of all the followings" do
      relationship_one = create(:relationship, :follower => @user, :followed => create(:user))
      relationship_two = create(:relationship, :follower => create(:user), :followed => @user)
      relationship_three = create(:relationship, :follower => @user, :followed => create(:user))
      get :followings, :id => @user
      expect(assigns(:followings)).to match_array([relationship_one, relationship_three])
    end

    it "renders the :followings template" do
      get :followings, :id => @user
      expect(response).to render_template("followings")
    end
  end

  describe "GET #followers" do
    it "populates an array of all the followers" do
      relationship_one = create(:relationship, :follower => create(:user), :followed => @user)
      relationship_two = create(:relationship, :follower => create(:user), :followed => @user)
      relationship_three = create(:relationship, :follower => @user, :followed => create(:user))
      get :followers, :id => @user
      expect(assigns(:followers)).to match_array([relationship_one, relationship_two])
    end

    it "renders the :followers template" do
      get :followers, :id => @user
      expect(response).to render_template("followers")
    end
  end

end