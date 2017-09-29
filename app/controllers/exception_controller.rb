class ExceptionController < ActionController::Base
  def render_error
    @exception = env["action_dispatch.exception"]
    @status_code = ActionDispatch::ExceptionWrapper.new(env, @exception).status_code
    if request.original_fullpath=~/^\/api\/v1.+$/
      render json: {status: {
                    code: 500,
                 message: 'Internal Server Error' } }
    else
      render :template => "errors/500", status: @status_code, layout: false
    end
  end
end
