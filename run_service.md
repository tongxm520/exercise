run project in development


##sudo su - postgres
## /usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data >logfile 2>&1 &
## /usr/local/pgsql/bin/pg_ctl start -l logfile -D /usr/local/pgsql/data

ps -A|grep postmaster

#sudo service redis_6379 start
#sudo service redis_6379 stop
#sudo service redis_6379 status

##run in development
cap unicorn:stop
sudo service unicorn_exercise start

cap nginx:stop
rake nginx:setup
sudo service nginx start

sudo service memcached stop
sudo service memcached start

# cap unicorn:stop
connection failed for: 192.168.1.102 (Errno::ECONNREFUSED: Connection refused - connect(2) for 192.168.1.102:22)

ifconfig 
vi config/deploy.rb
# change 192.168.1.102 to a new one

# Gem::InstallError: net-ssh requires Ruby version >= 2.2.6
fix=> add <gem 'net-ssh','4.2.0'> to Gemfile


# vi /etc/hosts
change 192.168.1.102 to a new one

# firefox=>advanced
No proxy for:
localhost, 127.0.0.1,www.exercise.com


tail -f log/development.log

# find process by PID
cat Rails.root.to_s/shared/pids/unicorn.pid
ps -p 6520 -o comm=
=>bundle
ps -A |grep bundle

sudo service unicorn_exercise stop
ps -A |grep bundle

sudo service unicorn_exercise start
ps -A |grep bundle

# bundle exec unicorn -c config/unicorn_develop.rb -E $ENV -D


# 中文trie树
# search suggestion trie树

Elasticsearch query with Tire

nested_filter = Tire::Search::Query.new do
  filtered do
    query { all }
    filter :term,  { 'apps_events.status' => 'active' }
    filter :terms, { 'apps_events.type'   => ['sale'] }
  end
end

tire.search(page: params[:page], per_page: params[:per_page], load: params[:load]) do
  query do
    filtered do
      query { all }
      # Merge the defined filter as a hash into the `nested` filter
      filter :nested, { path: 'apps_events'}.merge({ query: nested_filter.to_hash })
    end
  end
end


Configuration changed for Rails 4 and 5.
For Rails 4:
config.serve_static_files = true

For Rails 5:
config.public_file_server.enabled = true

rails3
config.serve_static_assets = true
#Rails Asset Pipeline: Serve static assets from the public directory 

#https://learn.co/lessons/images-and-the-asset-pipeline
The first of the helpers available to help us create image paths is the asset_path helper. It provides a way for us to get a relative path to an image file in the Asset Path. To use this helper, we specify the path relative to the assets folder.

asset_path('logo.png')
If the asset pipeline finds the file, it will return the path to the image.
/assets/logo.png

If the file is in a sub-folder in the images directory (images/banner), we need to include that as well.
asset_path('banner/logo.png')
/assets/banner/logo.png

If the asset pipeline can't find the file, the path returned will be / plus the file name.
/logo.png

The asset_path helper is great for image paths located in our CSS files.
.logo {
  background-image: url(<%= asset_path('logo') %>);
}

