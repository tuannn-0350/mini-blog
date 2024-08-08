require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { create :user }

  describe "GET /new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status :success
    end
  end

  describe "POST /create" do
    context "with valid params" do
      it "redirect to index" do
        post :create, params: {session: {email: user.email, password: user.password}}
        expect(response).to redirect_to root_url
      end
    end

    context "with invalid params" do
      it "render new" do
        post :create, params: {session: {email: user.email, password: "invalid"}}
        expect(response).to render_template :new
      end
    end
  end

  describe "DELETE /destroy" do
    it "redirect to login" do
      delete :destroy
      expect(response).to redirect_to login_url
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status :success
    end

    it "redirect to index if logged in" do
      log_in user
      get :new
      expect(response).to redirect_to root_url
    end
  end

  describe "DELETE /destroy" do
    it "redirect to login" do
      delete :destroy
      expect(response).to redirect_to login_url
    end

    it "log out" do
      log_in user
      delete :destroy
      expect(logged_in?).to be_falsey
    end
  end
end
