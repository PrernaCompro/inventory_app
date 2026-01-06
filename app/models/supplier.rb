class Supplier < ApplicationRecord
  has_many :products, dependent: :nullify

  validates :name,
    presence: { message: "can't be blank" },
    length: { minimum: 2, message: "must be at least 2 characters long" }

  validates :email,
    presence: { message: "can't be blank" },
    uniqueness: { message: "has already been taken" },
    format: {
      with: URI::MailTo::EMAIL_REGEXP,
      message: "is not a valid email address",
      allow_blank: true
    }

  validates :phone,
    presence: { message: "can't be blank" },
    format: {
      with: /\A[\d\s\-\+\(\)]+\z/,
      message: "is not a valid phone number (use digits, spaces, hyphens, parentheses, or plus sign)",
      allow_blank: true
    }

  scope :active, -> { where(active: true) }
    # scope :inactive, -> { where(active: false) }
  scope :alphabetical, -> { order(:name) }
  scope :recent, -> { order(created_at: :desc) }
  scope :with_products, -> { joins(:products).distinct }
  scope :without_products, -> { left_joins(:products).where(products: { id: nil }) }
  scope :search, ->(query) {
    return all if query.blank?
    where("name ILIKE ? OR email ILIKE ? OR phone ILIKE ?", 
          "%#{query}%", "%#{query}%", "%#{query}%")
  }

  def soft_delete
    update(active: false)
  end

  def reactivate
    update(active: true)
  end
end
