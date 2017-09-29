class StoreController < ApplicationController
  skip_before_filter :authorize
  
  def index
    #@products = Product.order("created_at desc")
    @first_level,@second_level,@third_level=Category.fetch_categories

    render layout: "store"
  end
end
