class CustomersController < ApplicationController
  def index
    @customers = Customer.order(:first_name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @customers }
    end
  end

  def show
    @customer = Customer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @customer }
    end
  end

  def new
    @customer = Customer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @customer }
    end
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def create
    @customer = Customer.new(params[:customer])

    respond_to do |format|
      if @customer.save
        format.html { redirect_to(customers_url,:notice => "Customer #{@customer.name} was successfully created." ) }
        format.json { render json: @customer, status: :created, location: @customer }
      else
        format.html { render action: "new" }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @customer = Customer.find(params[:id])

    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        format.html { redirect_to(customers_url,:notice => "Customer #{@customer.name} was successfully updated." ) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @customer = Customer.find(params[:id])
    begin
      @customer.destroy
      flash[:notice] = "Customer #{@customer.first_name} deleted"
    rescue Exception => e
      flash[:notice] = e.message
    end

    respond_to do |format|
      format.html { redirect_to customers_url }
      format.json { head :no_content }
    end
  end
end
