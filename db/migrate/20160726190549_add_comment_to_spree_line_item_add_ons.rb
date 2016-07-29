class AddCommentToSpreeLineItemAddOns < ActiveRecord::Migration
  def change
    add_column :spree_line_item_add_ons, :comment, :text
  end
end
