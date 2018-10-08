class StoreController < ApplicationController
  include CurrentCart
  skip_before_action :authorize
  before_action :set_cart

  def index
    if params[:set_locale]
      redirect_to store_index_url(locale: params[:set_locale])
    else
      @products = Product.order(:title)
      if session[:store_index_visit_counter].nil?
        session[:store_index_visit_counter] = 1
      else
        session[:store_index_visit_counter] += 1
      end
    end
  end
end
