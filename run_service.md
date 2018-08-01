run project in development

##sudo su - postgres
##/usr/local/pgsql/bin/postmaster -D /usr/local/pgsql/data >logfile 2>&1 &

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
localhost, 127.0.0.1,192.168.1.106,www.exercise.com

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











