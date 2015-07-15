require 'rails_helper'

describe PostsController do
  login_user

  let(:johns_goal) { create(:goal, :user => @user) }
  let(:johns_post) { create(:post, :goal => johns_goal) }

  describe "GET #index" do
    it "populates an array of all the posts" do
      post_one = create(:post, :goal => johns_goal)
      post_two = create(:post, :goal => johns_goal)
      get :index, :goal_id => johns_goal
      expect(assigns(:posts)).to match_array([post_one, post_two])
    end

    it "renders the :index template" do
      get :index, :goal_id => johns_goal
      expect(response).to render_template("index")
    end
  end

end