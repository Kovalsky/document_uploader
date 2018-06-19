require "rails_helper"

RSpec.describe "Strategy management" do

  context "with strategy according file_name" do
    let(:suppliers_path) { File.join(Rails.root, 'spec/services/document_uploader/files/suppliers.csv') }
    let(:products_path)     { File.join(Rails.root, 'spec/services/document_uploader/files/sku.csv') }

    it "should save 5 records from suppliers.csv" do
      DocumentUploader::Service.new.call(suppliers_path, 'suppliers.csv')
      expect(Supplier.count).to eq 5
    end

    context "with sku.csv" do

      it "shouldn't save records before if suppliers not exist" do
        begin
          DocumentUploader::Service.new.call(products_path, 'sku.csv')
        rescue ActiveRecord::InvalidForeignKey => e
          expect(e.message).to include('PG::ForeignKeyViolation')
        end
      end

      it "should save 5 records" do
        DocumentUploader::Service.new.call(suppliers_path, 'suppliers.csv')
        DocumentUploader::Service.new.call(products_path, 'sku.csv')

        expect(Supplier.count).to eq 5
        expect(Product.count).to eq 5
        expect(Product.first.supplier.code).to eq Product.first.supplier_code
      end
    end
  end
end
