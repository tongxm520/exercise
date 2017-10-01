module Api
  module V1
		class BaseController < ActionController::Base
			include ExceptionHandler
			include Pundit
		
			before_filter :authenticate_request

			attr_reader :current_user
			helper_method :current_user

			rescue_from Pundit::NotAuthorizedError, with: :deny_access

			private

			def process(action, *args)
				super
			rescue AbstractController::ActionNotFound => e
				respond_to do |format|
				  format.json { render :json => {:status => {
				                         :code=>404,
				                         :message=>e.message}}, 
				                         :status => :not_found }
				  format.any { render :text => "Error: #{e.message}", :status => :not_found }
				end
			end

			def authenticate_request
				@current_user = AuthenticateApiRequest.call(request.headers).result
			end

			def deny_access(e)
				api_error(status: 403,error: e)
			end

			def api_error(opts = {})
				respond_to do |format|
				  format.json { render :json => {:status => {
				                         :code=>opts[:status],
				                         :message=>opts[:error].message}}, 
				                         :status => opts[:status] }
				  format.any { render :text => "Error: #{opts[:error].message}",status: opts[:status] }
				end
			end
    end
  end
end

