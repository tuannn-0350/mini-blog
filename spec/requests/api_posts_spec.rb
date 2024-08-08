require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  let(:user) { create :user }
  let(:posts) { create_list :post, Settings.pagy.items, user: user }

  before do
    log_in user
  end

  describe "POST /create" do
    let(:post_params) { attributes_for :post }

    it "create a post" do
      expect do
        post :create, params: {post: post_params}
      end.to change(Post, :count).by(1)

      expect(response).to have_http_status :ok
    end
  end



end
