class StoreController < ApplicationController
  def index
    @products = Product.order(:title)
    if session[:store_index_visit_counter].nil?
      session[:store_index_visit_counter] = 1
    else
      session[:store_index_visit_counter] += 1
    end
  end
end
