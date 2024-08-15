require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  let(:user) { create :user }
  let(:other_user) { create :user }

  before do
    log_in user
  end

  describe "POST /create" do
    it "create a relationship" do
      expect do
        post :create, params: {followed_id: other_user.id}
      end.to change(Relationship, :count).by(1)
    end

    it "destroy a relationship" do
      user.follow other_user
      relationship = user.active_relationships.find_by(followed_id: other_user.id)
      expect do
        delete :destroy, params: {id: relationship.id}
      end.to change(Relationship, :count).by(-1)
    end
  end

end
