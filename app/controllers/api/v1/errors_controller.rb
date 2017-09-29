class Api::V1::ErrorsController < Api::V1::BaseController
  skip_before_filter :authenticate_request

  def routing
    respond_to do |format|
      format.json { render :json => {:status => {
                             :code=>404,
                             :message=>'Routing Error'}}, 
                             :status => :not_found }
      format.any { render :text => "Routing Error", :status => :not_found }
    end
  end
end
