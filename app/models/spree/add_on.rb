class Spree::AddOn < ActiveRecord::Base
  belongs_to :product, class_name: "Spree::Product"

  has_one(
    :default_price, -> { where(currency: Spree::Config[:currency]) },
    class_name: "Spree::AddOnPrice",
    dependent: :destroy
  )
  
  has_many :prices,
           class_name: "Spree::AddOnPrice",
           dependent: :destroy,
           inverse_of: :add_on

  accepts_nested_attributes_for :prices, allow_destroy: true

  scope :default, -> { where(default: true) }

  def price_in(currency)
    prices.find_by_currency(currency) ||
      self.build_default_price(currency: currency)
  end

  def self.types
    Rails.application.config.spree.add_ons
  end

  def self.description
    self.human_attribute_name(:type_description)
  end

  # rubocop:disable Metrics/LineLength
  def display_name
    "#{self.name} #{I18n.t('spree.addons.expires_in', count: self.expiration_days) if self.expiration_days}".strip
  end
  # rubocop:enable Metrics/LineLength

  def purchased!(line_item)
    # Do nothing.
  end
end
