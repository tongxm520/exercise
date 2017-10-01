module ExceptionHandler
  extend ActiveSupport::Concern

  ## Define custom error subclasses - rescue catches `StandardErrors`
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class ExpiredSignature < StandardError; end
  class TokenNotExist < StandardError; end

  included do
    # Define custom handlers
		#rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
		rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
		rescue_from ExceptionHandler::MissingToken, with: :four_twenty_two
		rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two
    rescue_from ExceptionHandler::TokenNotExist, with: :four_twenty_two
		rescue_from ExceptionHandler::ExpiredSignature, with: :four_twenty_two
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
  end

  private

  #Status code 422 - unprocessable entity
  def four_twenty_two(exception)
    respond_to do |format|
      format.json { render :json => {:status => {
                             :code=>422,
                             :message=>exception.message}}, 
                             :status => :unprocessable_entity }
      format.any { render :text => "Error: #{exception.message}", :status => :unprocessable_entity }
    end
  end

  #Status code 401 - Unauthorized
  def unauthorized_request(exception)
    respond_to do |format|
      format.json { render :json => {:status => {
                             :code=>401,
                             :message=>exception.message}}, 
                             :status => :unauthorized }
      format.any { render :text => "Error: #{exception.message}", :status => :unauthorized }
    end
  end

  #Status code 404 - Not Found
  def not_found(exception)
    respond_to do |format|
      format.json { render :json => {:status => {
                             :code=>404,
                             :message=>exception.message}}, 
                             :status => :not_found }
      format.any { render :text => "Error: #{exception.message}", :status => :not_found }
    end
  end
end
