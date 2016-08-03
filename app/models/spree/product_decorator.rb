module Spree
  Product.class_eval do
    has_many :add_ons, dependent: :destroy
    accepts_nested_attributes_for :add_ons, allow_destroy: true
  end
end
