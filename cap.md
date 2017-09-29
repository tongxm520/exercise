##initialize Capistrano

Run bundle install
Run capify .
Edit the file Capfile

# Capfile
load 'deploy'
load 'deploy/assets'
load 'config/deploy'

cap -T
###########################################################

First we’ll need to run cap deploy:install to update the server and install the software it needs.
$ cap deploy:install

This will take a good few minutes to install everything but we can just let it run. When it finishes we can run cap deploy:setup to setup the configuration for our application.
$ cap deploy:setup

We’ll need to type the password for deployer again and further down the recipe we’ll need to enter a password for Postgresql to use. The recipe will then create a database with that password. There’s just one more command we need to run to install our application.
$ cap deploy:cold

Once this command completes we can try browsing our application in the browser.

##cap deploy
##Capistrano connection failed for: 127.0.0.1
The error indicates that you cannot SSH to the destination box, in this case localhost. Try ssh 127.0.0.1, and make sure that works. The deployment should execute once that works.

##ssh simon@127.0.0.1
##ssh simon@192.168.1.102
If you can't do ssh 127.0.0.1, use:

##sudo apt-get install openssh-server
To install the ssh server

##Capistrano will not create releases
removing the line:
set :deploy_via, :remote_cache

##Rails Error: Unable to access log file.
sudo chmod 0666 production.log
These folders should be created by capistrano when you run cap deploy:setup, have you ran it? To check if everything is fine you can run cap deploy:check before it.



memcached -P /var/run/memcached/memcached.pid  -d -p 11211 -m 128 -c 1024
error while loading shared libraries: libevent-2.1.so.6
sudo find / -name "libevent-2.1.so.6"
cd /lib/i386-linux-gnu
##fix=>sudo ln -s /usr/local/lib/libevent-2.1.so.6.0.2 libevent-2.1.so.6


##cap deploy
##cap deploy:setup
##cap -T














