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

  describe "GET #new" do
    it "assigns a new post to @post" do
      get :new, :goal_id => johns_goal
      expect(assigns(:post)).to be_a_new(Post)
    end

    it "renders the :new template" do
      get :new, :goal_id => johns_goal
      expect(response).to render_template("new")
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new post in the database" do
        expect{
          post :create, :goal_id => johns_goal, post: attributes_for(:post, :goal => johns_goal)
        }.to change(Post, :count).by(1)
      end

      it "redirects to goals#index" do
        post :create, :goal_id => johns_goal, post: attributes_for(:post, :goal => johns_goal)
        expect(response).to redirect_to goal_posts_path(johns_goal)
      end
    end

    context "with invalid attributes" do
      it "does not save the new post in the database" do
        expect{
          post :create, :goal_id => johns_goal, post: attributes_for(:post, :goal => johns_goal, :content => nil)
        }.to_not change(Post, :count)
      end

      it "re-renders the :new template" do
        post :create, :goal_id => johns_goal, post: attributes_for(:post, :goal => johns_goal, :content => nil)
        expect(response).to render_template("new")
      end
    end
  end

end