class AuthenticateUser
  prepend SimpleCommand
  attr_accessor :user_id

  def initialize(email, password)
    @email = email
    @password = password 
    @user_id=nil  
  end

  def call
    if user
      token=JsonWebToken.encode(user_id: user.id)
      @user_id=user.id
      token
    end
  end

  private

  attr_accessor :email, :password

  def user
    user = Customer.find_by_email(email)
    return user if user && Customer.authenticate(email, password)
    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)

    #errors.add :user_authentication, Message.invalid_credentials
    #nil
  end
end


