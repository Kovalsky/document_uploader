require "rails_helper"

RSpec.describe Supplier, :type => :model do
  it "should create one after adding one" do
    supplier = FactoryGirl.create(:supplier)

    expect(Supplier.count).to eq 1
    expect([supplier.code, supplier.name]).to eq ['0000', 'Supplier_1']
  end

  it "should create none after adding not valid name" do
    supplier = FactoryGirl.build(:supplier, name: '')

    expect(supplier).to be_invalid
    expect(supplier.errors[:name]).to include("can't be blank")
  end

  it "should create none after adding not valid code" do
    supplier = FactoryGirl.build(:supplier, code: '')

    expect(supplier).to be_invalid
    expect(supplier.errors[:code]).to include("can't be blank")
  end

  it "should create none after adding not unique code" do
    supplier = FactoryGirl.create(:supplier)
    supplier_twin = FactoryGirl.build(:supplier)

    expect(supplier_twin).to be_invalid
    expect(supplier_twin.errors[:code]).to include("has already been taken")
  end

  it "should have code index for quick search" do
    expect(Supplier.connection.indexes(:suppliers).map(&:columns)).to include(["code"])
  end
end
