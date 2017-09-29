class AdminController < ApplicationController
  skip_before_filter :fetch_cart

  def index
    @likes=[]
    if current_customer
      @likes=current_customer.order_by_category
    end 
  end
end
