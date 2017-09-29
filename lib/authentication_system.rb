module AuthenticationSystem

  SKIP_LOCATIONS=['/login','/logout','/register','/users/forgot']
  SKIP_ACTIONS={"welcome"=>["login"]}

  protected
  def self.included(base)
		base.send :helper_method, :current_customer, :logged_in?, :authorized? if base.respond_to? :helper_method
	end

  def current_customer
    @current_customer ? @current_customer : login_from_session
  end
 
  def logged_in?
    !!current_customer
  end
  
  def authorized?(action = action_name, resource = nil)
    logged_in?
  end
  
  # Store the given user id in the session.
  def current_customer=(new_customer)
    session[:customer_id] = new_customer ? new_customer.id : nil
    @current_customer = new_customer ? new_customer : nil
  end
  
  # Called from #current_user.  First attempt to login by the user id stored in the session.
  def login_from_session
    Customer.find_by_id(session[:customer_id]) 
  end
  
  # Store the URI of the current request in the session.
  # We can return to this location by calling #redirect_back_or_default.
  def store_location
    session[:return_to] = request.original_url if request.request_method=="GET" and !request.xhr? and not skipped?(request)
  end
  
  # Redirect to the URI stored by the most recent store_location call or
  # to the passed default.  Set an appropriately modified
  #   after_filter :store_location, :only => [:index, :new, :show, :edit]
  # for any controller you want to be bounce-backable.
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  private
  def skipped?(request)
    if SKIP_LOCATIONS.index(request.original_fullpath)
      true
    else
      key=request.params[:controller]
      if SKIP_ACTIONS.has_key?(key) and SKIP_ACTIONS[key].index(request.params[:action])
        true
      else
        false
      end      
    end
  end    
    
end
