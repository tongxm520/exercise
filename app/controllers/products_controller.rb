class ProductsController < ApplicationController
  skip_before_filter :fetch_cart
  PER_PAGE=20

  # GET /products
  # GET /products.json
  def index
    @products = Product.offset(0).limit(PER_PAGE)
    if Product.count>PER_PAGE
      @page=2
    else
      @page=nil
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end
  end

  def load_more
    page=params[:page].to_i
    @products = Product.offset((page-1)*PER_PAGE).limit(PER_PAGE)
    if Product.count>page*PER_PAGE
      @page=page + 1
    else
      @page=nil
    end
    
    respond_to do |format|
      format.js
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url,notice: @product.errors[:base][0] }
      format.json { head :no_content }
    end
  end

  #/products/3/who_bought.atom
  def who_bought
    @product = Product.find(params[:id])
    respond_to do |format|
      format.atom
      format.xml { render :xml => @product }
    end
  end
end
