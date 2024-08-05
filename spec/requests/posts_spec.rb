require "rails_helper"
include SessionsHelper

RSpec.describe PostsController, type: :controller do
  let (:user) { create :user }
  let (:followed_user) { create :user }
  let! (:posts) { create_list :post, Settings.pagy.items, user: user }
  let! (:followed_user_posts) { create_list :post, Settings.pagy.items, user: followed_user }

  before do
    log_in user
    user.follow followed_user
  end

  describe "GET /index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "render the index template" do
      get :index
      expect(response).to render_template :index
    end

    context "when user is not logged in" do
      it "redirects to login page" do
        log_out
        get :index
        expect(response).to redirect_to login_path
      end
    end

    context "show posts" do
      it "show user's posts with limit equal #{Settings.pagy.items}" do
        get :index
        expect(assigns(:posts).inspect).to eql user.posts.order_by_created_at.inspect
        expect(assigns(:pagy)).to be_a Pagy
        expect(assigns(:posts).count).to eq Settings.pagy.items
      end
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it "render the new template" do
      get :new
      expect(response).to render_template :new
    end

    it "assigns a new post to @post" do
      get :new
      expect(assigns(:post)).to be_a_new Post
    end

    context "when user is not logged in" do
      it "redirects to login page" do
        log_out
        get :new
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "POST /create" do
    let(:invalid_params) { attributes_for(:post, body: "", title: "") }
    let(:params) { {post: attributes_for(:post)} }
    context "create a new post" do
      it "create a new post" do
        expect do
          post :create, params: params
        end.to change(Post, :count).by 1

        expect(Post.last.body).to eq params.dig(:post, :body)
        expect(response).to redirect_to user_posts_path(user)
      end

      it "create a new post failed" do
        post :create, params: {post: invalid_params}
        expect(response).to render_template :new
      end
    end

    context "when user is not logged in" do
      it "redirects to login page" do
        log_out
        post :create, params: params
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "GET /show" do
    let(:post) { user.posts.first }

    it "returns http success" do
      get :show, params: {id: post.id}
      expect(response).to have_http_status(:success)
    end

    it "render the show template" do
      get :show, params: {id: post.id}
      expect(response).to render_template :show
    end

    it "assigns the requested post to @post" do
      get :show, params: {id: post.id}
      expect(assigns(:post)).to eq post
    end

    context "when post is not found" do
      it "redirects to user's posts page" do
        get :show, params: {id: 0}
        expect(response).to redirect_to root_path
        expect(flash[:danger]).to eq I18n.t("post_not_found")
      end
    end
  end

  describe "GET /edit" do
    let(:post) { user.posts.first }

    it "returns http success" do
      get :edit, params: {
        id: post.id
      }
      expect(response).to have_http_status(:success)
    end

    it "render the edit template" do
      get :edit, params: {id: post.id}
      expect(response).to render_template :edit
    end

    it "assigns the requested post to @post" do
      get :edit, params: {id: post.id}
      expect(assigns(:post)).to eq post
    end

    context "when user is not logged in" do
      it "redirects to login page" do
        log_out
        get :edit, params: {id: post.id}
        expect(response).to redirect_to login_path
      end
    end

    context "when not correct user" do
      it "redirects to user's posts page" do
        get :edit, params: {id: 0 }
        expect(response).to redirect_to user_posts_path(user)
      end
    end
  end

  describe "PATCH /update" do
    let(:post) { user.posts.first }
    let(:params) { {id: post.id, post: {body: "Hello world", title: "Hello"}} }

    context "update post" do
      it "update post" do
        patch :update, params: params
        post.reload
        expect(post.body).to eq params.dig(:post, :body)
        expect(post.title).to eq params.dig(:post, :title)
        expect(response).to redirect_to user_posts_path(user)
      end

      it "update post failed" do
        patch :update, params: {id: post.id, post: {body: "", title: ""}}
        expect(response).to render_template :edit
      end
    end

    context "when user is not logged in" do
      it "redirects to login page" do
        log_out
        patch :update, params: params
        expect(response).to redirect_to login_path
      end
    end

    context "when not correct user" do
      it "redirects to user's posts page" do
        patch :update, params: {id: Post.last.id, post: {body: "Hello world", title: "Hello"}}
        expect(response).to redirect_to user_posts_path(user)
      end
    end
  end

  describe "DELETE /destroy" do
    let(:post) { posts.first }

    context "delete post" do
      it "delete post" do
        expect do
          delete :destroy, params: {id: post.id}
        end.to change(Post, :count).by -1
        expect(response).to redirect_to user_posts_path(user)
      end
    end

    context "when user is not logged in" do
      it "redirects to login page" do
        log_out
        delete :destroy, params: {id: post.id}
        expect(response).to redirect_to login_path
      end
    end

    context "when not correct user" do
      it "redirects to user's posts page" do
        delete :destroy, params: {id: 0}
        expect(flash[:danger]).to eql I18n.t("post_not_found")
        expect(response).to redirect_to user_posts_path(user)
      end
    end

    context "when delete post failed" do
      before do
        allow_any_instance_of(Post).to receive(:destroy).and_return(false)
      end

      it "redirects to user's posts page" do
        delete :destroy, params: {id: post.id}
        expect(flash[:danger]).to eql I18n.t("post_delete_failed")
        expect(response).to redirect_to user_posts_path(user)
      end
    end
  end

  describe "GET /feed" do
    it "returns http success" do
      get :feed
      expect(response).to have_http_status(:success)
    end

    it "render the feed template" do
      get :feed
      expect(response).to render_template :feed
    end

    it "show user's feed with limit equal #{Settings.pagy.items}" do
      get :feed
      expect(assigns(:posts).inspect).to\
             eql Post.published.feed(user.following_ids).inspect
      expect(assigns(:pagy)).to be_a Pagy

      expect(assigns(:posts).count).to eq Settings.pagy.items
    end
  end
end
