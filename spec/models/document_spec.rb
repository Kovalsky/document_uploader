require "rails_helper"

RSpec.describe Document, :type => :model do

  it "should create one after adding any of [suppliers.csv, sku.csv]" do
    %w[suppliers.csv sku.csv].each.with_index do |file, i|
      FactoryGirl.create(:document, attachment_file_name: file)
      expect(Document.count).to eq i + 1
    end
  end

  it "should create none after adding not valid file_name" do
    document = FactoryGirl.build(:document, attachment_file_name: 'text.csv')

    expect(document).to be_invalid
    expect(document.errors[:attachment_file_name]).to include("is invalid")
  end

  it "should create none after adding not valid content_type" do
    document = FactoryGirl.build(:document, attachment_content_type: 'application/pdf')

    expect(document).to be_invalid
    expect(document.errors[:attachment_content_type]).to include("is invalid")
  end
end
