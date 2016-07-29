module Spree
  module Api
    module V1
      class AddOnsController < Spree::Api::BaseController
        include Spree::PermittedAttributes
        before_action :find_product,
                      if: proc { params[:product_id].present? }
        before_action :add_on, only: [:show, :update, :destroy]

        def index
          @add_ons = @product.add_ons.
                     accessible_by(current_ability, :read).
                     page(params[:page]).per(params[:per_page])
          respond_with(@add_ons)
        end

        def show
          respond_with(@add_on)
        end

        def new
        end

        # rubocop:disable Metrics/MethodLength
        def create
          authorize! :create, AddOn
          @add_on = @product.add_ons.new(add_on_params)
          if @add_on.save
            respond_with(@add_on, status: 201, default_template: :show)
          else
            invalid_resource!(@add_on)
          end
        end

        def update
          if @add_on
            authorize! :update, @add_on
            @add_on.update_attributes(add_on_params)
            respond_with(@add_on, status: 200, default_template: :show)
          else
            invalid_resource!(@add_on)
          end
        end

        def destroy
          if @add_on
            authorize! :destroy, @add_on
            @add_on.destroy
            respond_with(@add_on, status: 204)
          else
            invalid_resource!(@add_on)
          end
        end
        # rubocop:enable Metrics/MethodLength

        private

        def find_product
          @product = super(params[:product_id])
          authorize! :read, @product
        end

        # rubocop:disable Metrics/MethodLength
        def add_on
          if @product
            @add_on ||= @product.add_ons.find_by(id: params[:id])
          else
            @add_on = Spree::AddOn.find(params[:id])
          end
          authorize! :read, @add_on
        end
        # rubocop:enable Metrics/MethodLength

        def add_on_params
          params.require(:add_on).permit(@@add_on_attributes)
        end
      end
    end
  end
end
