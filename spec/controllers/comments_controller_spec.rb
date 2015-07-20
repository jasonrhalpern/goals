require 'rails_helper'

describe CommentsController do
  login_user

  let(:johns_comment) { build(:comment) }

  describe "POST #create" do

    context "with valid attributes" do
      it "saves the new comment in the database" do
        expect{
          xhr :post, :create, post_id: johns_comment.post, comment: { content: johns_comment.content }
        }.to change(Comment, :count).by(1)
      end

      it "returns a 200 status code" do
        xhr :post, :create, post_id: johns_comment.post, comment: { content: johns_comment.content }
        expect(response.status).to be(200)
      end

      it "renders the create template" do
        xhr :post, :create, post_id: johns_comment.post, comment: { content: johns_comment.content }
        expect(response).to render_template('create')
      end
    end

    context "with invalid attributes" do
      it "does not save the new comment in the database" do
        expect{
          xhr :post, :create, post_id: johns_comment.post, comment: { content: nil }
        }.to_not change(Comment, :count)
      end

      it "renders the create template" do
        xhr :post, :create, post_id: johns_comment.post, comment: { content: nil }
        expect(response).to render_template('create')
      end
    end
  end

end