require "spec_helper"
# rubocop:disable Metrics/ModuleLength
module Spree
  describe Api::V1::AddOnsController, type: :controller do
    render_views

    let!(:product) { create(:product) }
    let!(:add_on_1) do
      product.add_ons.create(
        name: "Inscription",
        description: "my value 1",
        default: false,
        prices_attributes: [
          amount: 9.99
        ]
      )
    end
    let!(:add_on_2) do
      product.add_ons.create(
        name: "Inscription 2",
        description: "my value 2",
        default: false,
        prices_attributes: [
          amount: 9.49
        ]
      )
    end
    let(:new_attributes) do
      [
        "description", "name", "type", "default", "expiration_days",
        "prices_attributes" => ["amount"]
      ]
    end
    let(:attributes) do
      [
        :id, :product_id, :name, :description, :display_amount
      ]
    end
    let(:resource_scoping) { { product_id: product.to_param } }
    before do
      stub_authentication!
    end

    context "if product is deleted" do
      before do
        product.update_column(:deleted_at, 1.day.ago)
      end

      it "can not see a list of product add_ons" do
        api_get :index
        expect(response.status).to eq(404)
      end
    end

    it "cannot create a new product add_on if not an admin" do
      api_post :create, add_on: { name: "My Add On 3" }
      assert_unauthorized!
    end

    it "cannot update a product add_on" do
      api_put :update, id: add_on_1.name, add_on: { value: "my value 456" }
      assert_unauthorized!
    end

    it "cannot delete a product add_on" do
      api_delete :destroy, id: add_on_1.to_param, name: add_on_1.name
      assert_unauthorized!
      expect { add_on_1.reload }.not_to raise_error
    end

    context "as an admin" do
      let(:current_api_user) do
        user = Spree.user_class.
               new(email: "spree@example.com", password: "password")
        user.generate_spree_api_key!
        user
      end
      before do
        allow(current_api_user).to receive(:has_spree_role?) { true }
      end

      it "can see a list of all product add_ons" do
        api_get :index
        expect(json_response["add_ons"].count).to eq 2
        expect(json_response["add_ons"].first).to include(*attributes)
      end

      it "can learn how to create a new product add_on" do
        api_get :new
        expect(json_response["attributes"]).to eq(new_attributes)
        expect(json_response["required_attributes"]).to be_empty
      end

      it "can control the page size through a parameter" do
        api_get :index, per_page: 1
        expect(json_response["add_ons"].count).to eq(1)
        expect(json_response["current_page"]).to eq(1)
        expect(json_response["pages"]).to eq(2)
      end

      it "can see a single add_on" do
        api_get :show, id: add_on_1.id
        expect(json_response).to include(*attributes)
      end

      it "can create a new product add_on" do
        expect do
          api_post(
            :create,
            add_on: {
              name: "My Add On 3", prices_attributes: [amount: 9.99]
            }
          )
        end.to change(product.add_ons, :count).by(1)
        expect(json_response).to include(*attributes)
        expect(response.status).to eq(201)
      end

      it "can update a product add_on" do
        api_put(
          :update,
          id: add_on_1.id,
          add_on: { prices_attributes: [amount: 99.99] }
        )
        expect(response.status).to eq(200)
      end

      it "can delete a product add_on" do
        api_delete :destroy, id: add_on_1.id
        expect(response.status).to eq(204)
        expect { add_on_1.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      context "with product identified by id" do
        let(:resource_scoping) { { product_id: product.id } }
        it "can see a list of all product add_ons" do
          api_get :index
          expect(json_response["add_ons"].count).to eq 2
          expect(json_response["add_ons"].first).to include(*attributes)
        end

        it "can see a single add_on by id" do
          api_get :show, id: add_on_1.id
          expect(json_response).to include(*attributes)
        end
      end
    end
  end
end
# rubocop:enable Metrics/ModuleLength
