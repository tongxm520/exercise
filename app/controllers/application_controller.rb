class ApplicationController < ActionController::Base
  before_filter :authorize
  before_filter :fetch_cart
  protect_from_forgery
  
  include AuthenticationSystem
  
  rescue_from(ActiveRecord::RecordNotFound) {
    render :template => 'errors/404',:layout => false
  }
  
  private

  def render_error(exception = nil)
    render :template => "errors/500", :status => 500, :layout => false
  end

  def process(action, *args)
    super
  rescue AbstractController::ActionNotFound
    respond_to do |format|
      format.html { render :template => 'errors/404',:layout => false, status: :not_found }
      format.all { render nothing: true, status: :not_found }
    end
  end

  def current_cart
    Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
    cart = Cart.create
    session[:cart_id] = cart.id
    cart
  end

  protected

  def authorize
    store_location
    unless authorized?
      redirect_to login_url, :notice => "Please log in"
    end
  end

  def fetch_cart
    @cart = current_cart
  end
end


=begin
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, :with => :render_error
    rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found   
    rescue_from ActionController::RoutingError, :with => :render_not_found
    rescue_from AbstractController::ActionNotFound, :with => :render_not_found
  end 

  #called by last route matching unmatched routes.  Raises RoutingError which will be rescued from in the same way as other exceptions.
  def raise_not_found!
    raise ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
  end

  #render 500 error 
  def render_error(e)
    respond_to do |f| 
      f.html{ render :template => "errors/500", :status => 500 }
      f.js{ render :partial => "errors/ajax_500", :status => 500 }
    end
  end
  
  #render 404 error 
  def render_not_found(e)
    respond_to do |f| 
      f.html{ render :template => "errors/404", :status => 404 }
      f.js{ render :partial => "errors/ajax_404", :status => 404 }
    end
  end
=end


