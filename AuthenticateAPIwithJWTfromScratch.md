##google: rails api jwt
##json web token mobile app
##json web token authentication
##Introducing OAuth2 for Mobile API Security


Authentication is one of the vital parts of any web application. There are innumerable libraries and frameworks that provide various options to perform authentication one way or another. These libraries take away much of the groundwork required to setup an authentication system, providing “magic” with what’s happening behind the scenes. For Rails, we have a number of authentication systems, the prominent one being Devise.

Devise is an authentication engine that runs as part of our application and does all the heavy lifting when it comes to authentication. However, often times we don’t need many of the parts it provides. For example, Devise doesn’t work very well with API-based systems, which is why we have the devisetokenauth gem. devisetokenauth is a library that does what Devise does, but with tokens instead of sessions.

Today we’re going to explore building our own custom JWT-based authentication system from scratch. Let’s get started.

##NOTE: This Tutorial is aimed for API-based authentication.

##Why JWT

JWT (JSON Web Token, pronounced “jot”) is a self-contained authentication standard designed for securely exchanging data between systems. Since it’s self-contained, it doesn’t need any backing storage to work. Also, the JWT approach is very reliable and flexible, allowing it to be used with any client. It doesn’t have any overhead to get started and almost all languages have libraries that make working with JWTs a breeze.

We already have an excellent tutorial about JWT and how to use it with Rails. If you’re new to JWT I’d suggest you to read it first to get an idea of what we’re going to create.

##Model
We’ll begin by building a model for our app. The application will authenticae users, so let’s create a User model.
rails g model user

This command will create a migration file under db/migrate called XXXcreateusers, where XXX is the current date. Add the following code to this file, which will add the columns we need:
create_table :users do |t|
  t.string :email,              null: false
  t.string :password_digest,    null: false
  t.string   :confirmation_token
  t.datetime :confirmed_at
  t.datetime :confirmation_sent_at

  t.timestamps
end

Run rake db:migrate to run the migration.

We’re adding email and password_digest columns here, which are the basic columns required to register or authenticate a user. Of course, you can add more columns that makes sense, if you like. The confirmation_token, confirmed_at, and confirmation_sent_at columns are required for user confirmation. You can skip this if you don’t wish to confirm the emails.

##Validations

Let’s add our validations to models/user.rb:

validates_presence_of :email
validates_uniqueness_of :email, case_sensitive: false
validates_format_of :email, with: /@/

We’re validating the uniqueness of email without case sensitivity and doing a simple format check of the email ensuring there is a @ in the email string. This might not be a solid validation, but there is no standard one and that’s why we verify the email upon registration.


##Callbacks

We are going to make use of Rails’s hassecurepassword for handling the password hashing.

To start, add the gem bcrypt (it’s probably there, but commented out) to your Gemfile and run bundle install. Once the gem is installed, add the following line inside the User class in the file models/user.rb:

class User < ApplicationRecord
  has_secure_password
end

Let’s also add callbacks that we want to perform before user creation. First, we’d want to lowercase the email and strip any spaces. Second, we’d have to generate a confirmation token that will be sent in the email to the user.

Add these before callbacks to the models/user.rb file:

before_save :downcase_email
before_create :generate_confirmation_instructions

We downcase the email before saving it to the DB. The confirmation instructions should be generated only during the creation of the user record. Let’s add the methods:

def downcase_email
  self.email = self.email.delete(' ').downcase
end

def generate_confirmation_instructions
  self.confirmation_token = SecureRandom.hex(10)
  self.confirmation_sent_at = Time.now.utc
end

If you plan to skip the confirmation, you can omit the above method and the corresponding callback.

##Registration
Create

We now have the model setup, so let’s add an endpoint for user creation. Create our users controller:

rails g controller users

Add the below line to config/routes.rb:

resources :users, only: :create

We now have generated our UsersController. Head over to the controller (app/controllers/users_controller.rb) and add the following lines:

def create
  user = User.new(user_params)

  if user.save
    render json: {status: 'User created successfully'}, status: :created
  else
    render json: { errors: user.errors.full_messages }, status: :bad_request
  end
end

private

def user_params
  params.require(:user).permit(:email, :password, :password_confirmation)
end

We now have an API endpoint to create a user! You can try it by starting the server and sending a POST request with the user details as JSON in the body. Here’s an example of what you could post to http://localhost:3000/users:

{
  user: {
    email: 'test@example.com',
    password: 'anewpassword',
    password_confirmation: 'anewpassword'
  }
}

You should receive the User created successfully message as the response. Subsequent requests with the same data should respond with error messages. That’s our validations in play. For those who are skipping the confirmation part, you can skip the following and head to the Login section.

##Confirmation

One thing that is pending is the user confirmation. We are going to send an email confirmation to the user before creation and create an endpoint that validates the token to confirm the user.

To start, we have to send an email to the user when the record is successfully created. We wouldn’t be going through how to send emails since there are already good tutorials that cover how to do it. We should add the line to send email right after user.save in users_controller.

...
if user.save
  #Invoke send email method here
...

Just make sure that you include the user.confirmation_token in your email. Ideally, the URL should lead to an endpoint that fetches the token and posts it to our API. Let’s create that post API endpoint.

Adda route to our config/routes.rb file for the confirm endpoint:

resources :users, only: :create do
  collection do
    post 'confirm'
  end
end

Now, create the confirm action in UsersController:

def confirm
  token = params[:token].to_s

  user = User.find_by(confirmation_token: token)

  if user.present? && user.confirmation_token_valid?
    user.mark_as_confirmed!
    render json: {status: 'User confirmed successfully'}, status: :ok
  else
    render json: {status: 'Invalid token'}, status: :not_found
  end
end

Let’s see what we’re doing here. First, we are fetching the token from params, calling to_s to handle the case where the token is not sent in the request. Next, fetch the corresponding user based on the confirmation token.

If the user is present and the confirmation isn’t expired, call the model method mark_as_confirmed! and respond with a success message. We have to add the confirmation_token_valid? and mark_as_confirmed! methods to our User model:

def confirmation_token_valid?
  (self.confirmation_sent_at + 30.days) > Time.now.utc
end

def mark_as_confirmed!
  self.confirmation_token = nil
  self.confirmed_at = Time.now.utc
  save
end

The confirmation_token_valid? method checks if the confirmation was sent in the last 30 days and, thus, is not expired. You can change it to any value you wish.

mark_as_confirmed! saves the confirmed time and nullifies the confirmation token so that the same confirmation email can’t be used to confirm the user again.

We now have the endpoint to confirm a user. You can test it by sending a post request to the endpoint users/confirm?token=<CONFIRMATION_TOKEN> and check the confirmed_at and confirmation_token value for the user. You should get User confirmed successfully. Subsequent requests with the same token should return Invalid token.

We now have a working registration as part of our app. Let’s create the final piece: the login endpoint.


##Login

For login, we are going to create an endpoint to log the user in by sending the credentials of the user and responding with a JWT token. We also will add a helper method that can be used to secure endpoints that we want to be exposed only to authenticated users.
Controller

Let’s add the login route to our config/routes.rb file under users resource:

resources :users, only: :create do
    collection do
      post 'confirm'
      post 'login'
    end
end

We have created a users/login route now. The controllers require some modification to pull in the json_web_token code and create the corresponding action in the UsersController.

In controllers/application_controller.rb, add the below line right after the class definition:

require 'json_web_token'

In controllers/users_controller.rb add the following snippet:

def login
  user = User.find_by(email: params[:email].to_s.downcase)

  if user && user.authenticate(params[:password])
      auth_token = JsonWebToken.encode({user_id: user.id})
      render json: {auth_token: auth_token}, status: :ok
  else
    render json: {error: 'Invalid username / password'}, status: :unauthorized
  end
end

Let’s go over this method step by step. First, we’re fetching the user from the email and, if present, call the authenticate method passing the password that is supplied. The authenticate method is provided by the has_secure_password helper.

Once we verify the email and password, encode the user’s id into a JWT token via our encode method from JsonWebToken lib which we have yet to create. Then, return the token.

For those who are confirming emails, we have to disallow users who aren’t confirmed. Modify the controller action to include one more conditional:

...
if user && user.authenticate(params[:password])
  if user.confirmed_at?
    auth_token = JsonWebToken.encode({user_id: user.id})
    render json: {auth_token: auth_token}, status: :ok
  else
    render json: {error: 'Email not verified' }, status: :unauthorized
  end
else
...

Checking if the confirmed_at field is not empty does the job, meaning user has been confirmed before allowing them to login.

##JWT Library

Now, let’s add the JWT library. Begin by adding the following gem to your Gemfile and do bundle install:

gem 'jwt'

Once done, create a file called jsonwebtoken.rb under lib/ and add these lines:

require 'jwt'

class JsonWebToken
  # Encodes and signs JWT Payload with expiration
  def self.encode(payload)
    payload.reverse_merge!(meta)
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  # Decodes the JWT with the signed secret
  def self.decode(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base)
  end

  # Validates the payload hash for expiration and meta claims
  def self.valid_payload(payload)
    if expired(payload) || payload['iss'] != meta[:iss] || payload['aud'] != meta[:aud]
      return false
    else
      return true
    end
  end

  # Default options to be encoded in the token
  def self.meta
    {
      exp: 7.days.from_now.to_i,
      iss: 'issuer_name',
      aud: 'client',
    }
  end

  # Validates if the token is expired by exp parameter
  def self.expired(payload)
    Time.at(payload['exp']) < Time.now
  end
end

Let’s go through the code. First, in the encode method, merge the payload which is the user id with meta information such as expiry, issuer, and audience. You can learn about these “meta” claims from the JWT tutorial linked at the beginning of this post. Once merged, encode the payload using the JWT.encode method along with the secret key from our server. It is important that this key is kept secure since this is the master key for all the tokens our app issues.

Then, the decode method, which uses the decode method from the jwt gem to (you guessed it) decode the payload using the secret key. We have a couple of other helper methods, one is valid_payload which validates if the payload has been tampered with, and the expired method which validates whether the token has expired. The default expiry is set in the meta method which is 7 days, but you are free to change it as per your requirement.

Now we have a functioning login endpoint that we can use to login the user. Try calling the endpoint users/login with the below formatted data in the request body:

{
  "email": "test@example.com",
  "password": "anewpassword"
}

You should see a response similar to this,

{
  "auth_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE0NzUzMTM5OTQsImlzcyI6Imlzc3Vlcl9uYW1lIiwiYXVkIjoiY2xpZW50In0.5P3qJKelCdbTixnLyIrsLKSVnRLCv2lvHFpXqVKdPOs"
}

There it is. Our authentication token for the user. We can now use this token to validate each request for the user.


##Authentication Helper

Alright, we are going to create a helper method that gets the token from the header, validates the payload, and fetches the corresponding user from the DB. Open up /app/controllers/application_controller.rb and add the following:

protected
# Validates the token and user and sets the @current_user scope
def authenticate_request!
  if !payload || !JsonWebToken.valid_payload(payload.first)
    return invalid_authentication
  end

  load_current_user!
  invalid_authentication unless @current_user
end

# Returns 401 response. To handle malformed / invalid requests.
def invalid_authentication
  render json: {error: 'Invalid Request'}, status: :unauthorized
end

private
# Deconstructs the Authorization header and decodes the JWT token.
def payload
  auth_header = request.headers['Authorization']
  token = auth_header.split(' ').last
  JsonWebToken.decode(token)
rescue
  nil
end

# Sets the @current_user with the user_id from payload
def load_current_user!
  @current_user = User.find_by(id: payload[0]['user_id'])
end

Here, authenticate_request! is the helper method that we are going to use to authenticate controller actions. It fetches the payload from the Authorization header of the request, then validates the payload using the valid_payload method, which we’ve seen before. Once confirmed valid, it fetches the user using the user_id in the payload, loading the user record into the scope.

We can now add the authenticate_request method as a before_filter to any controller action that we want to be authenticated for the user.

##Conclusion

With that we have come to the conclusion of this tutorial. We covered the meaty aspects of user authentication – registration, confirmation, and login – all through an API using JWT. You can take this forward as is or make any sort of modifications to parts of it, maybe adding separate components like password reset, email update, locking accounts, and much more.


