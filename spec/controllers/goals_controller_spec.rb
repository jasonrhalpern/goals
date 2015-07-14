require 'rails_helper'

describe GoalsController do
  login_user

  let(:johns_goal) { create(:goal, :user => @user) }

  describe "GET #index" do
    it "populates an array of all the goals" do
      goal_one = create(:goal, :user => @user)
      goal_two = create(:goal, :status => Goal.statuses[:completed], :user => @user)
      get :index, :user_id => @user
      expect(assigns(:goals)).to match_array([goal_one, goal_two])
    end

    it "renders the :index template" do
      get :index, :user_id => @user
      expect(response).to render_template("index")
    end
  end

  describe "GET #new" do
    it "assigns a new goal to @goal" do
      get :new, :user_id => @user
      expect(assigns(:goal)).to be_a_new(Goal)
    end

    it "renders the :new template" do
      get :new, :user_id => @user
      expect(response).to render_template("new")
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new goal in the database" do
        expect{
          post :create, :user_id => @user, goal: attributes_for(:goal, :user_id => @user)
        }.to change(Goal, :count).by(1)
      end

      it "redirects to goals#index" do
        post :create, :user_id => @user, goal: attributes_for(:goal, :user_id => @user)
        expect(response).to redirect_to user_goals_path(@user)
      end
    end

    context "with invalid attributes" do
      it "does not save the new goal in the database" do
        expect{
          post :create, :user_id => @user, goal: attributes_for(:goal, :description => nil)
        }.to_not change(Goal, :count)
      end

      it "re-renders the :new template" do
        post :create, :user_id => @user, goal: attributes_for(:goal, :description => nil)
        expect(response).to render_template("new")
      end
    end
  end

  describe "GET #edit" do
    it "assigns the requested goal to @goal" do
      get :edit, :id => johns_goal
      expect(assigns(:goal)).to eq(johns_goal)
    end

    it "renders the :edit template" do
      get :edit, :id => johns_goal
      expect(response).to render_template("edit")
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "changes the goal" do
        patch :update, id: johns_goal, goal: attributes_for(:goal, :description => 'My new goal description')
        johns_goal.reload
        expect(johns_goal.description).to eq('My new goal description')
      end

      it "redirects to the updated goal" do
        patch :update, id: johns_goal, goal: attributes_for(:goal, :user => @user)
        expect(response).to redirect_to user_goals_path(@user)
      end
    end

    context "with invalid attributes" do
      it "does not change the goal" do
        patch :update, id: johns_goal, goal: attributes_for(:goal, :title => nil, :description => 'My new goal description')
        johns_goal.reload
        expect(johns_goal.description).to_not eq('My new goal description')
      end

      it "re-renders the edit template" do
        patch :update, id: johns_goal, goal: attributes_for(:goal, :description => nil)
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @my_goal = create(:goal, :user => @user)
    end

    it "deletes the goal" do
      expect{
        delete :destroy, id: @my_goal
      }.to change(Goal, :count).by(-1)
    end

    it "redirects to goals#index" do
      delete :destroy, id: @my_goal
      expect(response).to redirect_to user_goals_path(@user)
    end
  end

end