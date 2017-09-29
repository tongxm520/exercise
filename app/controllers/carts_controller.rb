class CartsController < ApplicationController
  skip_before_filter :authorize, :only => [:destroy,:show]

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    @cart = Cart.find(params[:id])
    @cart.destroy
    session[:cart_id] = nil

    respond_to do |format|
      format.html  { redirect_to(store_url) }
      format.json { head :no_content }
    end
  end

  def show
    @shopping_cart=Cart.find(params[:id])
    render layout: "store"
  end
end
