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
      relationship_one = create(:relationship, :follower => @user, :followed => create(:user))
      relationship_two = create(:relationship, :follower => create(:user), :followed => @user)
      relationship_three = create(:relationship, :follower => @user, :followed => create(:user))
      get :following, :id => @user
      expect(assigns(:relationships)).to match_array([relationship_one, relationship_three])
    end

    it "renders the :following template" do
      get :following, :id => @user
      expect(response).to render_template("show_follow")
    end
  end

  describe "GET #followers" do
    it "populates an array of all the followers" do
      relationship_one = create(:relationship, :follower => create(:user), :followed => @user)
      relationship_two = create(:relationship, :follower => create(:user), :followed => @user)
      relationship_three = create(:relationship, :follower => @user, :followed => create(:user))
      get :followers, :id => @user
      expect(assigns(:relationships)).to match_array([relationship_one, relationship_two])
    end

    it "renders the :followers template" do
      get :followers, :id => @user
      expect(response).to render_template("show_follow")
    end
  end

end