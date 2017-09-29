wget  http://download.redis.io/releases/redis-4.0.2.tar.gz
cd /home/simon/Downloads/stanford/redis-4.0.2
make
make test
sudo make install

Once the program has been installed, Redis comes with a built in script that sets up Redis to run as a background daemon.
cd utils
sudo ./install_server.sh

Selected config:
Port           : 6379
Config file    : /etc/redis/6379.conf
Log file       : /var/log/redis_6379.log
Data dir       : /var/lib/redis/6379
Executable     : /usr/local/bin/redis-server
Cli Executable : /usr/local/bin/redis-cli

You can start and stop redis with these commands (the number depends on the port you set during the installation. 6379 is the default port setting):

sudo service redis_6379 start
sudo service redis_6379 stop

You can then access the redis database by typing the following command:
##redis-cli

##netstat -an | grep ':6379'

To set Redis to automatically start at boot, run:
##sudo update-rc.d redis_6379 defaults

Open the Redis configuration file for editing:
sudo nano /etc/redis/6379.conf























