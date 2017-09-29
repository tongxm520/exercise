class Api::V1::AuthenticationController < Api::V1::BaseController
  skip_before_filter :authenticate_request, only: :authenticate

  def authenticate
    command=AuthenticateUser.call(auth_params[:email],auth_params[:password])
    if command.success?
      render json: {status: {code: 200,message: 'OK' },
                 data: {auth_token: command.result} }
    end
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end

