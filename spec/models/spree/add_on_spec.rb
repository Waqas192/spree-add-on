require "spec_helper"

describe Spree::AddOn, type: :model do
  let(:add_on) { build :add_on }

  it { should belong_to :product }
  it { should have_one(:default_price).dependent(:destroy) }
  it { should have_many(:prices).dependent(:destroy) }

  describe "#price_in" do
    context "when a price with the currency exists" do
      let(:add_on) { create :add_on }
      let!(:add_on_price) do
        add_on.prices.create!(amount: 4.99, currency: "CAD")
      end
      it { expect(add_on.price_in("CAD")).to eq add_on_price }
    end
    context "when no matching price exists" do
      let(:add_on) { create :add_on }
      it { expect(add_on.price_in("CAD")).to be_a_new Spree::AddOnPrice }
      it { expect(add_on.price_in("CAD").currency).to eq "CAD" }
    end
  end

  describe "#display_name" do
    subject { add_on.display_name }

    it { should == add_on.name + " (Expires in 30 days)" }

    context "add on has no expiration" do
      let(:add_on) { build :add_on, expiration_days: nil }
      it { should == add_on.name }
    end
  end

  describe "::default" do
    let(:default_add_on) { create :add_on, default: true }
    subject { Spree::AddOn.default }
    it { should match_array [default_add_on] }
  end

  describe "::types" do
    class Spree::AddOn::DummyAddOn < Spree::AddOn
    end

    before do
      Rails.application.config.spree.add_ons << Spree::AddOn::DummyAddOn
    end
    subject { Spree::AddOn.types }
    it { should match_array [Spree::AddOn::DummyAddOn] }
  end

  describe "::description" do
    subject { Spree::AddOn.description }
    it { should eq Spree::AddOn.human_attribute_name(:type_description) }
  end
end
