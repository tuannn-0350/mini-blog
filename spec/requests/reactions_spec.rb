require 'rails_helper'

RSpec.describe ReactionsController, type: :controller do
  let(:user) { create :user }
  let!(:user_post) { create :post, user: user }
  let(:other_user) { create :user }
  let!(:other_post) { create :post, user: other_user }
  before do
    log_in user
  end

  shared_examples "redirect to root" do

  end


  describe "POST /create" do

    context "when post is not exist" do
      it "redirect to root" do
        allow(Post).to receive(:find_by).and_return(nil)
        post :create, params: {post_id: other_post.id}
        expect(response).to redirect_to root_url
      end
    end

    it "create a reaction" do
      expect do
        post :create, params: {post_id: other_post.id}
      end.to change(Reaction, :count).by(1)
    end
  end

  describe "DELETE /destroy" do
    before do
      user.like other_post
    end

    context "when post is not exist" do
      it "redirect to root" do
        allow(Post).to receive(:find_by).and_return(nil)
        delete :destroy, params: {id: other_post.id}
        expect(response).to redirect_to root_url
      end
    end

    it "destroy a reaction" do
      reaction = user.reactions.find_by(post_id: other_post.id)
      expect do
        delete :destroy, params: {id: other_post.id}
      end.to change(Reaction, :count).by(-1)
    end
  end
end
