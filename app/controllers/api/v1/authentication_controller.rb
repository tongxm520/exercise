class Api::V1::AuthenticationController < Api::V1::BaseController
  skip_before_filter :authenticate_request, only: :authenticate

  def authenticate
    command=AuthenticateUser.call(auth_params[:email],auth_params[:password])
    if command.success?
      save_token(command.result,command.user_id)
      render json: {status: {code: 200,message: 'OK' },
                 data: {auth_token: command.result} }
    end
  end

  private

  def auth_params
    params.permit(:email, :password)
  end

  #Time.now-Time.parse("2017-10-01 19:26:54")>60.seconds
  #token = JSON.load($redis.get("user-#{user_id}"))
  def save_token(result,user_id)
    token={}
    now=Time.now.strftime("%Y-%m-%d %H:%M:%S")
    token["login_at"]=now
    token["access_at"]=now
    token["auth_token"]=result
    token["valid"]=true
    $redis.set("user-#{user_id}", token.to_json)
  end
end

