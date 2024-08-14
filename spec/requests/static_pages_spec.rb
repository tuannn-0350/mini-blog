require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do
  let (:user) { create :user }

  before do
    log_in user
  end

  describe "GET /index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
