class Supplier < ApplicationRecord
  has_many :products, dependent: :nullify

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true
end
