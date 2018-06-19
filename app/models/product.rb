class Product < ApplicationRecord

  belongs_to :supplier, foreign_key: :supplier_code, primary_key: :code

  validates :sku, :supplier_code, :name, :price, presence: true
  validates :sku, uniqueness: true
  
end
