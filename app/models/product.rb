class Product < ApplicationRecord
  belongs_to :supplier

  validates :name,
    presence: { message: "can't be blank" },
    length: {
      minimum: 2,
      maximum: 255,
      message: "must be between 2 and 255 characters"
    }

  validates :price,
    presence: { message: "can't be blank" },
    numericality: {
      greater_than: 0,
      message: "must be greater than 0"
    }

  validates :quantity,
    presence: { message: "can't be blank" },
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0,
      message: "must be 0 or greater"
    }

  validates :sku,
    uniqueness: {
      message: "has already been taken",
      case_sensitive: false  # SKU123 and sku123 are considered duplicates
    },
    allow_nil: true,
    format: {
      with: /\A[A-Z0-9\-]+\z/i,
      message: "can only contain letters, numbers, and hyphens",
      allow_blank: true
    }

  scope :active, -> { where(active: true) }
  # scope :inactive, -> { where(active: false) }
  scope :in_stock, -> { where("quantity > 0") }
  scope :out_of_stock, -> { where(quantity: 0) }
  scope :low_stock, -> { where("quantity > 0 AND quantity <= reorder_level") }
  scope :alphabetical, -> { order(:name) }
  scope :by_price_asc, -> { order(:price) }
  scope :by_price_desc, -> { order(price: :desc) }
  scope :by_quantity_asc, -> { order(:quantity) }
  scope :by_quantity_desc, -> { order(quantity: :desc) }
  scope :recent, -> { order(created_at: :desc) }
  scope :recently_updated, -> { order(updated_at: :desc) }
  scope :price_between, ->(min, max) { where(price: min..max) }
  scope :by_supplier, ->(supplier_id) { where(supplier_id: supplier_id) }
  scope :from_active_suppliers, -> { joins(:supplier).where(suppliers: { active: true }) }
  scope :search, ->(query) {
    return all if query.blank?
    where("name ILIKE ? OR sku ILIKE ? OR description ILIKE ?",
          "%#{query}%", "%#{query}%", "%#{query}%")
  }
end
