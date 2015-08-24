require 'rails_helper'

describe RelationshipsController do
  login_user

  let(:johns_relationship) { create(:relationship, :follower => @user) }

  describe "POST #create" do
    before(:each) do
      @user_two = create(:user)
    end

    context "with valid attributes" do
      it "saves the new relationship in the database" do
        expect{
          xhr :post, :create, { followed_id: @user_two.id }
        }.to change(Relationship, :count).by(1)
      end

      it "returns a 200 status code" do
        xhr :post, :create, { followed_id: @user_two.id }
        expect(response.status).to be(200)
      end

      it "re-renders the toggle template" do
        xhr :post, :create, { followed_id: @user_two.id }
        expect(response).to render_template('create')
      end
    end

    context "with invalid attributes" do
      it "does not save the new relationship in the database" do
        expect{
          xhr :post, :create, { followed_id: nil }
        }.to_not change(Relationship, :count)
      end
    end
  end


  describe "DELETE #destroy" do
    before(:each) do
      @relationship = create(:relationship, :follower => @user, :followed => create(:user))
    end

    it "deletes the relationship" do
      expect{
        xhr :post, :destroy, id: @relationship.id
      }.to change(Relationship, :count).by(-1)
    end

    it "returns a 200 status code" do
      xhr :post, :destroy, id: @relationship.id
      expect(response.status).to be(200)
    end

    it "re-renders the toggle template" do
      xhr :post, :destroy, id: @relationship.id
      expect(response).to render_template('destroy')
    end
  end


end