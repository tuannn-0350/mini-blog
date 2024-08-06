require 'rails_helper'
include SessionsHelper

RSpec.describe UsersController, type: :controller do
  let(:user) { create :user }
  let(:users) { create_list :user, Settings.pagy.items }

  before do
    log_in user
  end

  shared_examples "render the template" do |action: nil|

    it "render the #{ action } template" do
      get action, params: {id: user.id}
      expect(response).to render_template action
    end
  end

  shared_examples "return http success" do |action: nil|
    it "returns http success" do
      get action, params: {id: user.id}
      expect(response).to have_http_status :success
    end
  end



  describe "GET /index" do
    let (:params) { {} }

    it_behaves_like "return http success", action: :index

    it_behaves_like "render the template", action: :index

    context "show users" do
      it "show users with limit equal #{Settings.pagy.items}" do
        get :index
        expect(assigns(:users).inspect).to eql\
               User.order_by_name.limit(Settings.pagy.items).inspect
        expect(assigns(:pagy)).to be_a Pagy
        expect(assigns(:users).count).to eq Settings.pagy.items
      end
    end
  end

  describe "GET /new" do
    it_behaves_like "return http success", action: :new

    it_behaves_like "render the template", action: :new

    it "assigns a new user to @user" do
      get :new
      expect(assigns(:user)).to be_a_new User
    end
  end

  describe "GET /show" do
    let!(:posts) { create_list :post, Settings.pagy.items, user: user }

    include_examples "return http success", action: :show

    it_behaves_like "render the template", action: :show

    context "show posts" do
      it "show user's posts with limit equal #{Settings.pagy.items}" do
        get :show, params: {id: user.id}
        expect(assigns(:posts).inspect).to eql \
               user.posts.published.order_by_created_at.inspect
        expect(assigns(:pagy)).to be_a Pagy
        expect(assigns(:posts).count).to eq Settings.pagy.items
      end
    end

    context "when user is not found" do
      it "redirects to root_url" do
        allow(User).to receive(:find_by).and_return(nil)
        get :show, params: {id: user.id}
        expect(response).to redirect_to root_url
      end
    end
  end
end
