require "rails_helper"

RSpec.describe "Products management", :type => :request do

  it "should render products list" do
    get "/products"
    expect(response).to render_template(:index)
  end
end
