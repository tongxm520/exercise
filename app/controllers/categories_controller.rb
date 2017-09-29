class CategoriesController < ApplicationController
  skip_before_filter :authorize, :only => [:show]

  def show
    @cat=Category.find(params[:id])
    @ancestors=Category.find(@cat.ancestor.split("/"))
    @products=@cat.products
    #TODO:support first or second level category
    
    render layout: "store"
  end
end


