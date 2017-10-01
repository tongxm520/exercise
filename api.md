##As of Rails 5, autoloading is disabled in production because of thread safety.
This is a huge concern for us since lib is part of auto-load paths. To counter this change, we'll add our lib in app since all code in app is auto-loaded in development and eager-loaded in production. Here's a long discussion on [the above](https://github.com/rails/rails/issues/13142).

rails2.3.x vs rails3.2.22 vs rails4.1 vs rails5.0

class ApplicationController < ActionController::Base
  unless Rails.application.config.consider_all_requests_local
		rescue_from Exception, with: :render_exception
		rescue_from ActiveRecord::RecordNotFound, with: :render_exception
		rescue_from ActionController::UnknownController, with: :render_exception
		rescue_from ::AbstractController::ActionNotFound, with: :render_exception
		rescue_from ActiveRecord::ActiveRecordError, with: :render_exception
		rescue_from NoMethodError, with: :render_exception
  end
end

"/categories"
AbstractController::ActionNotFound

##rake db:create RAILS_ENV=production
##rails s -e production 
##(bundle exec) rake assets:precompile RAILS_ENV=production
##rails c production
##rails runner script/load_products.rb -e production

##ActionView::Template::Error (application.css isn't precompiled)
@import "jquery-ui-1.12.1-css/jquery-ui"; =>
@import "jquery-ui-1.12.1-css/jquery-ui.css";=>
*= require jquery-ui-1.12.1-css/jquery-ui

config.assets.precompile += %w(css/ionicons.css bootstrap.origin.css exercise.css flexslider.min.css owl.carousel.css store.css green.css scaffolds.css.scss)

##rake assets:precompile RAILS_ENV=production

Sass::SyntaxError: Invalid CSS after "...XImageTransform": expected ")", was ".Microsoft.grad..."
(in /home/simon/exercise/app/assets/stylesheets/bootstrap.origin.css)
##fix=>
filter: progid: DXImageTransform.Microsoft.gradient(enabled=false);=>
filter: unquote("progid:DXImageTransform.Microsoft.gradient(enabled=false)");

##=>generate assets in public

jquery.menu-aim.js isn't precompiled
config.assets.precompile += %w(jquery.menu-aim.js owl.carousel.min.js jquery.raty.min.js)

##Asset Precompilation OK,but 404 when trying to get files
config.serve_static_assets = true

##Rails 3.2.1 app in production running slow=>
The problem was the asset pipeline
deploy with nginx+puma

##gem source --remove http://gems.ruby-china.org/
##gem source --add https://rubygems.org


rake db:drop RAILS_ENV=production
ActiveRecord::StatementInvalid: PG::ObjectInUse: ERROR:  database "exercise_prod

##fix=>
ps aux|grep post
postgres  3857   exercise_prod 127.0.0.1(52962) idle
postgres  3858   exercise_prod 127.0.0.1(52964) idle
postgres  3881   exercise_prod 127.0.0.1(52968) idle

sudo kill -9 3857
sudo kill -9 3858
sudo kill -9 3881

rake db:drop RAILS_ENV=production
rake db:create RAILS_ENV=production
rake db:migrate RAILS_ENV=production
rake db:load_data RAILS_ENV=production
cd spider
ruby parse_html.rb "production"
rails runner script/load_products.rb -e production

#######################################################
As you correctly note, the **Accept** header is used by HTTP clients to tell the server what content types they'll accept. The server will then send back a response, which will include a **Content-Type** header telling the client what the content type of the returned content actually is.

However, as you may have noticed, HTTP requests can also contain **Content-Type** headers. Why? Well, think about POST or PUT requests. With those request types, the client is actually sending a bunch of data to the server as part of the request, and the **Content-Type** header tells the server what the data actually is (and thus determines how the server will parse it).

In particular, for a POST request resulting from an HTML form submission, the **Content-Type** of the request will (normally) be one of the standard form content types below, as specified by the enctype attribute on the <form> tag:

**application/x-www-form-urlencoded** (default, older, simpler, slightly less overhead for small amounts of simple ASCII text, no file upload support)
**multipart/form-data** (newer, adds support for file uploads, more efficient for large amounts of binary data or non-ASCII text)
#######################################################

{
    "data": {
        "LoginSession": {
            "session": true,
            "user": {
                "username": "admin",
                "id": "A3BD18A4-48C2-11E4-8F60-0050562B9EF5",
                "permissionrights": [
                    {
                        "permissions": {
                            "allowCreate": false,
                            "allowDelete": false,
                            "allowUpdate": false,
                            "allowRead": false,
                            "allowQuery": false
                        }
                    },
                    {
                        "permissions": {
                            "allowCreate": true,
                            "allowDelete": true,
                            "allowUpdate": true,
                            "allowRead": true,
                            "allowQuery": true
                        }
                    }
                ]
            }
        }
    },
    "status": {
        "code": 200,
        "message": "OK"
    }
}

curl -i http://www.exercise.com/api/v1/customers/1.json
curl -i http://www.exercise.com/api/v1/customers/100.json
curl -i http://www.exercise.com/api/v1/sessions
curl -i http://www.exercise.com/api/v1/session
curl -i http://www.exercise.com/api/v1/customers

curl -H "Content-Type: application/json" -X POST -d '{"email":"peter@163.com","password":"admin123"}' http://www.exercise.com/api/v1/authenticate

curl -H "Content-Type: application/json" -X POST -d '{"email":"peter@163.com","password":"admin123456"}' http://www.exercise.com/api/v1/authenticate

curl -H "Content-Type: application/json" -X POST -d '{"email":"peter@gmail.com","password":"admin123"}' http://www.exercise.com/api/v1/authenticate

$ curl -H "Authorization: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo4LCJleHAiOjE1MDYxMTI2NzN9.miGk8VsvXpk84yPnj7IV3kFtHTAfmQ8JTxgfOFXzAII" -i http://www.exercise.com/api/v1/customers/1.json

$ curl -H "Authorization: invalid-token" -i http://www.exercise.com/api/v1/customers/1.json

$ curl -H "Authorization: eyJ0eXAiOiJKV1QiLCJhbGci0IJIUzI1NiJ9.eyJ1c2VyX2lkIjo4LCJleHAiOjE1MDYxMTI2NzN9.miGk8VsvXpk84yPnj7IV3kFtHTAfmQ8JTxgfOFXzAII" -i http://www.exercise.com/api/v1/customers/1.json

$ curl -H "Authorization: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJleHAiOjE1MDYxNDY4Mjd9.Xyi11Q-86wogx-ToQxxf3kBbFpnmI0vZVA6KCp-DHcQ" -i http://www.exercise.com/api/v1/customers/1.json

curl -i -X PUT -d "customer[user_name]=victoria&customer[email]=victoria@163.com"  http://www.exercise.com/api/v1/customers/2 -H "Authorization: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJleHAiOjE1MDYxNDY4Mjd9.Xyi11Q-86wogx-ToQxxf3kBbFpnmI0vZVA6KCp-DHcQ"

curl -i -X PUT -d "customer[user_name]=victoria&customer[email]=victoria@163.com"  http://www.exercise.com/api/v1/customers/3 -H "Authorization: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJleHAiOjE1MDYxNDY4Mjd9.Xyi11Q-86wogx-ToQxxf3kBbFpnmI0vZVA6KCp-DHcQ"

curl -i http://www.exercise.com/api/v1/customers/1.json -H "Authorization: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJleHAiOjE1MDYxNDY4Mjd9.Xyi11Q-86wogx-ToQxxf3kBbFpnmI0vZVA6KCp-DHcQ"

curl -i http://www.exercise.com/api/v1/customers/1.json -H "Authorization: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJleHAiOjE1MDY5NDExNzd9.fNbyLEL8xfn9ARQVoYKNQlNKhmBDUaIHQCMdll6GaB4"













