class Api::V1::CustomersController < Api::V1::BaseController
  skip_before_filter :authenticate_request, only: [:create]

  def show
    @customer=Customer.find(params[:id])
  end

  def update
    @customer=Customer.find(params[:id])
    #return api_error(status: 403) if !CustomerPolicy.new(current_user,@customer).update?
    #pundit provide an simplified alternative with method <authorize> to authenticate privilege
    authorize @customer, :update?
    @customer.update_attributes(update_params)
  end

  private
  def update_params
    params.require(:customer).permit(:user_name,:email)
  end
end


