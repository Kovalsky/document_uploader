require "rails_helper"

RSpec.describe Product, :type => :model do

  it "should create none if supplier not exist" do
    begin
      FactoryGirl.create(:product)
    rescue ActiveRecord::RecordInvalid => e
      expect(e.message).to eq "Validation failed: Supplier must exist"
    end
  end

  context "with supplier" do
    before :each do
      FactoryGirl.create(:supplier)
    end

    it "should create one after adding one" do
      product = FactoryGirl.create(:product)

      expect(Product.count).to eq 1
      expect([product.sku, product.supplier_code, product.price.to_f]).to eq ['0001', '0000', 234.21]
    end

    it "should create none after adding not valid sku" do
      product = FactoryGirl.build(:product, sku: '')

      expect(product).to be_invalid
      expect(product.errors[:sku]).to include("can't be blank")
    end

    it "should create none after adding not valid supplier_code" do
      product = FactoryGirl.build(:product, supplier_code: '')

      expect(product).to be_invalid
      expect(product.errors[:supplier_code]).to include("can't be blank")
    end

    it "should create none after adding not unique sku" do
      product = FactoryGirl.create(:product)
      product_twin = FactoryGirl.build(:product)

      expect(product_twin).to be_invalid
      expect(product_twin.errors[:sku]).to include("has already been taken")
    end
  end

  it "should have index on sku" do
    expect(Supplier.connection.indexes(:products).map(&:columns)).to include(["sku"])
  end
end
