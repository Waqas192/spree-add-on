object false
child(@add_ons => :add_ons) do
  attributes(:id, :product_id, :name, :description, :display_amount)

  child(prices: :prices) do
    attributes(:id, :amount)
  end
end
node(:count) { @add_ons.count }
node(:current_page) { params[:page] || 1 }
node(:pages) { @add_ons.total_pages }
