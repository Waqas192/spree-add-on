node(:attributes) do
  [
    :description, :name, :type, :default, :expiration_days,
    prices_attributes: [:amount]
  ]
end
node(:required_attributes) { [] }
