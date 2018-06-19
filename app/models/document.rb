class Document < ApplicationRecord

  SUPPLIER_FILE_NAME = 'suppliers.csv'
  GOODS_FILE_NAME = 'sku.csv'

  has_attached_file :attachment

  validates_attachment_content_type :attachment, content_type: ['text/csv']
  validates_attachment_file_name :attachment, matches: [SUPPLIER_FILE_NAME, GOODS_FILE_NAME]
  
end
