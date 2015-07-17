require 'rails_helper'

describe MilestonesController do
  login_user

  let(:johns_goal) { create(:goal, :user => @user) }
  let(:johns_milestone) { create(:milestone, :goal => johns_goal) }

  describe "GET #index" do
    it "populates an array of all the milestones" do
      milestone_one = create(:milestone, :goal => johns_goal)
      milestone_two = create(:milestone, :goal => johns_goal)
      get :index, :goal_id => johns_goal
      expect(assigns(:milestones)).to match_array([milestone_one, milestone_two])
    end

    it "renders the :index template" do
      get :index, :goal_id => johns_goal
      expect(response).to render_template("index")
    end
  end

  describe "GET #new" do
    it "assigns a new milestone to @milestone" do
      get :new, :goal_id => johns_goal
      expect(assigns(:milestone)).to be_a_new(Milestone)
    end

    it "renders the :new template" do
      get :new, :goal_id => johns_goal
      expect(response).to render_template("new")
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new milestone in the database" do
        expect{
          post :create, :goal_id => johns_goal, milestone: attributes_for(:milestone, :goal => johns_goal)
        }.to change(Milestone, :count).by(1)
      end

      it "redirects to milestones#index" do
        post :create, :goal_id => johns_goal, milestone: attributes_for(:milestone, :goal => johns_goal)
        expect(response).to redirect_to goal_milestones_path(johns_goal)
      end
    end

    context "with invalid attributes" do
      it "does not save the new milestone in the database" do
        expect{
          post :create, :goal_id => johns_goal, milestone: attributes_for(:milestone, :goal => johns_goal, :title => nil)
        }.to_not change(Milestone, :count)
      end

      it "re-renders the :new template" do
        post :create, :goal_id => johns_goal, milestone: attributes_for(:milestone, :goal => johns_goal, :title => nil)
        expect(response).to render_template("new")
      end
    end
  end

  describe "GET #show" do
    it "assigns the requested milestone to @milestone" do
      get :show, :id => johns_milestone
      expect(assigns(:milestone)).not_to be_nil
    end

    it "renders the :show template" do
      get :show, :id => johns_milestone
      expect(response).to render_template("show")
    end
  end

  describe "GET #edit" do
    it "assigns the requested milestone to @milestone" do
      get :edit, :id => johns_milestone
      expect(assigns(:milestone)).to eq(johns_milestone)
    end

    it "renders the :edit template" do
      get :edit, :id => johns_milestone
      expect(response).to render_template("edit")
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "changes the milestone" do
        patch :update, id: johns_milestone, milestone: attributes_for(:milestone, :title => 'My new milestone title')
        johns_milestone.reload
        expect(johns_milestone.title).to eq('My new milestone title')
      end

      it "redirects to the updated milestone" do
        patch :update, id: johns_milestone, milestone: attributes_for(:milestone, :title => 'My new milestone title')
        expect(response).to redirect_to milestone_path(johns_milestone)
      end
    end

    context "with invalid attributes" do
      it "does not change the milestone" do
        patch :update, id: johns_milestone, milestone: attributes_for(:milestone, :title => 'My new milestone title', :description => nil)
        johns_milestone.reload
        expect(johns_milestone.title).to_not eq('My new milestone title')
      end

      it "re-renders the edit template" do
        patch :update, id: johns_milestone, milestone: attributes_for(:milestone, :title => 'My new milestone title', :description => nil)
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @my_milestone = create(:milestone, :goal => johns_goal)
    end

    it "deletes the milestone" do
      expect{
        delete :destroy, id: @my_milestone
      }.to change(Milestone, :count).by(-1)
    end

    it "redirects to milestones#index" do
      delete :destroy, id: @my_milestone
      expect(response).to redirect_to goal_milestones_path(johns_goal)
    end
  end

end