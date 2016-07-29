Spree::OrderUpdater.class_eval do
  # use line_item.amount instead of line_item.price to include add-ons
  def update_item_total
    order.item_total = line_items.inject(0) { |m, li| m + li.amount }
    update_order_total
  end
end
