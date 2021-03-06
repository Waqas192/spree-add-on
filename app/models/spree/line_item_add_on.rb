class Spree::LineItemAddOn < ActiveRecord::Base
  validates :add_on, :line_item, presence: true

  belongs_to :add_on
  belongs_to :line_item

  delegate :expiration_days, to: :add_on

  after_create :set_price_and_expiration_date

  def expired?
    return false unless add_on.expiration_days

    (self.created_at + add_on.expiration_days.days).past?
  end

  def money
    Spree::Money.new(self.price, currency: currency)
  end

  def purchased!
    add_on.purchased! line_item
  end

  private

  # rubocop:disable Metrics/LineLength
  def set_price_and_expiration_date
    self.expiration_date = DateTime.current + expiration_days.days if expiration_days

    self.price = self.add_on.price_in(currency).amount
    self.save!
  end
  # rubocop:enable Metrics/LineLength

  def currency
    self.line_item.order.currency
  end
end
