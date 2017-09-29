class LineItemsController < ApplicationController
  skip_before_filter :authorize
  skip_before_filter :fetch_cart, :only => [:reduce,:add,:destroy]

  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product.id)

    respond_to do |format|
      if @line_item.save
        format.html  { redirect_to(store_url) }
        format.js { @current_item = @line_item }
        format.json { render json: @line_item, status: :created, location: @line_item }
      else
        format.html { render action: "new" }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def reduce
    @status= params[:quantity].to_i>1
    if @status
      @item=LineItem.find(params[:id])
      @item.quantity-=1
      @item.save
      @shopping_cart=@item.cart
    end
  end

  def add
    @status= params[:quantity].to_i>0
    if @status
      @item=LineItem.find(params[:id])
      @item.quantity+=1
      @item.save
      @shopping_cart=@item.cart
    end
  end

  def destroy
    @item = LineItem.find_by_id(params[:id])
    @shopping_cart=nil
    if @item
      @shopping_cart=@item.cart
      @item.destroy 
    end

    respond_to do |format|
      format.js
    end
  end
end
