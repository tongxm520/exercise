class SessionsController < ApplicationController
  skip_before_filter :authorize
  
  def new
  end

  def create
    if customer = Customer.authenticate(params[:email], params[:password])
      self.current_customer= customer
      redirect_back_or_default(admin_url)
    else
      redirect_to login_url, :alert => "Invalid user/password combination"
    end
  end

  def destroy
    session[:customer_id] = nil
    @current_customer = nil
    @cart = nil
    redirect_to store_url, :notice => "Logged out"
  end
end
