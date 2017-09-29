require 'action_dispatch/middleware/show_exceptions'

module ActionDispatch
  class ShowExceptions
=begin
    def render_exception(env, exception)
			if exception.kind_of? ActionController::RoutingError
			  #render(404, 'it was routing error')
			  render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
			else
			  #render(500, "some other error")
			  render :file => "#{RAILS_ROOT}/public/500.html", :status => 500
			end
		end 
=end
   
    private

    def render_exception_with_template(env, exception)
=begin
      if exception.kind_of? AbstractController::ActionNotFound
        request = Request.new(env)
        if request.env['action_dispatch.request.path_parameters'][:controller] =~ /^api\/.+/
          return Api::V1::BaseController.action(:render_404_as_json).call(env)
        end
      end
=end

      body = ErrorsController.action(rescue_responses[exception.class.name]).call(env)
      log_error(exception)
      body
    rescue
      render_exception_without_template(env, exception)
    end

    alias_method_chain :render_exception, :template
  end
end


