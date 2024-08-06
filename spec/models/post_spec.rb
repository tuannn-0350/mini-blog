require 'rails_helper'

RSpec.describe Post, type: :model do
  shared_examples "validates presence of" do |attribute|
    it { is_expected.to validate_presence_of attribute }
  end

  shared_examples "validates length of" do |attribute, max_length, min_length=0|
    it { is_expected.to validate_length_of(attribute).is_at_most max_length }
    it { is_expected.to validate_length_of(attribute).is_at_least min_length }
  end

  shared_examples "has many" do |model|
    it { is_expected.to have_many model }
  end

  shared_examples "belongs to" do |model|
    it { is_expected.to belong_to model }
  end

  shared_examples "scope" do |name, scope|
    it { expect(described_class).to respond_to name }
    it { expect(described_class.send(name)).to eq scope }
  end

  describe "validations" do
    it_behaves_like "validates presence of", :title
    it_behaves_like "validates presence of", :body

    it_behaves_like "validates length of",
                    :title,
                    Settings.post.title_max_length
    it_behaves_like "validates length of",
                    :body,
                    Settings.post.body_max_length
  end

  describe "associations" do
    it_behaves_like "belongs to", :user
    it_behaves_like "has many", :reactions
    it_behaves_like "has many", :reactors
  end

  describe "scopes" do
    it_behaves_like "scope", :published, described_class.where(status: true)
    it_behaves_like "scope", :order_by_created_at, described_class.order(created_at: :desc)
  end

  describe "delegate" do
    it { is_expected.to delegate_method(:name).to(:user).with_prefix }
  end

  describe "feed" do
    let(:user) { create :user }
    let(:user2) { create :user }
    let(:post) { create :post, user: user }
    let(:post2) { create :post, user: user2 }
    let(:following_ids) { user.following_ids }
    let(:feed) { described_class.feed following_ids }

    before do
      user.follow user2
    end

    it "show feed" do
      expect(feed).to include post2
      expect(feed).not_to include post
    end
  end
end
