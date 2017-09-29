class OrdersController < ApplicationController

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.paginate :page=>params[:page],:order=> 'created_at desc',:per_page => 10

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.json
  def new
    if current_cart.line_items.empty?
      redirect_to store_url, :notice => "Your cart is empty"
      return
    end

    if order_params
      create
      return
    end

    @order = Order.new

    respond_to do |format|
      format.html {render layout: "store"}
      format.json { render json: @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(current_cart)
    
    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        format.html { redirect_to(store_url, :notice =>'Thank you for your order.' ) }
        format.json { render json: @order, status: :created, location: @order }
      else
        format.html { render action: "new",layout: "store"  }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end

  private

  def order_params
    if params[:order].nil?  || params[:order].empty?
      return false
    else
      params[:order][:customer_id]=current_customer.id
      return params.require(:order).permit(:street,:town,:zip,:pay_type,:phone,:customer_id)
    end
  end
end
