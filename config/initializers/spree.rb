module Spree
  module PermittedAttributes
    @@line_item_attributes.push add_on_ids: []
    @@add_on_price_attributes = [:currency, :amount]
    @@add_on_attributes = [:description, :name, :type, :default,
                           :expiration_days,
                           prices_attributes: [:id, :amount]]
  end
end
