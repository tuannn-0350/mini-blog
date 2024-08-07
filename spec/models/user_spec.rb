require 'rails_helper'

RSpec.describe User, type: :model do
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
    it_behaves_like "validates presence of", :name
    it_behaves_like "validates presence of", :email
    it_behaves_like "validates presence of", :password

    it_behaves_like "validates length of",
                    :name,
                    Settings.user.name_max_length,
                    Settings.user.name_min_length
    it_behaves_like "validates length of",
                    :email,
                    Settings.user.email_max_length,
                    Settings.user.email_min_length
    it_behaves_like "validates length of",
                    :password,
                    Settings.user.password_max_length,
                    Settings.user.password_min_length
  end

  describe "associations" do
    it_behaves_like "has many", :posts
    it_behaves_like "has many", :active_relationships
    it_behaves_like "has many", :passive_relationships
    it_behaves_like "has many", :following
    it_behaves_like "has many", :followers
    it_behaves_like "has many", :reactions
    it_behaves_like "has many", :reacted_posts
  end

  describe "scopes" do
    it_behaves_like "scope", :order_by_name, described_class.order(name: :asc)
  end
end
