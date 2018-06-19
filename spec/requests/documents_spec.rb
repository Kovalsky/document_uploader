require "rails_helper"

RSpec.describe "Document management", :type => :request do

  it "should render correct template" do
    get "/documents/new"
    expect(response).to render_template(:new)
  end
end
