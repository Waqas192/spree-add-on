Deface::Override.new(
  virtual_path: "spree/shared/_order_details",
  name: "order_details_add_ons",
  insert_bottom: "[data-hook='order_item_description']",
  partial: "spree/add_ons/order_add_ons",
  disabled: false
)

Deface::Override.new(
  virtual_path: "spree/shared/_order_details",
  name: "order_details_add_on_prices",
  replace_contents: "[data-hook='order_item_price']",
  partial: "spree/add_ons/order_add_on_prices",
  disabled: false,
  sequence: 101
)

Deface::Override.new(
  virtual_path: "spree/checkout/_delivery",
  name: "delivery_add_on_prices",
  replace_contents: ".item-price",
  text: "<%= item.line_item.single_money_with_add_ons %>",
  disabled: false
)
