class ProductsController < ApplicationController
  def index
    @products = Product.includes(:supplier).paginate(:page => params[:page])
  end
end
