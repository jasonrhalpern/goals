require 'rails_helper'

describe UsersController do
  login_user

  describe "GET #show" do
    it "assigns the requested user to @user" do
      get :show, :id => @user
      expect(assigns(:user)).not_to be_nil
    end

    it "renders the :show template" do
      get :show, :id => @user
      expect(response).to render_template("show")
    end
  end

  describe "GET #following" do
    it "populates an array of all the following" do
      user_two, user_three = create(:user), create(:user)
      create(:relationship, :follower => @user, :followed => user_two)
      create(:relationship, :follower => create(:user), :followed => @user)
      create(:relationship, :follower => @user, :followed => user_three)
      get :following, :id => @user
      expect(assigns(:users)).to match_array([user_two, user_three])
    end

    it "renders the :following template" do
      get :following, :id => @user
      expect(response).to render_template("show_follow")
    end
  end

  describe "GET #followers" do
    it "populates an array of all the followers" do
      user_two, user_three = create(:user), create(:user)
      create(:relationship, :follower => user_two, :followed => @user)
      create(:relationship, :follower => user_three, :followed => @user)
      create(:relationship, :follower => @user, :followed => create(:user))
      get :followers, :id => @user
      expect(assigns(:users)).to match_array([user_two, user_three])
    end

    it "renders the :followers template" do
      get :followers, :id => @user
      expect(response).to render_template("show_follow")
    end
  end

end