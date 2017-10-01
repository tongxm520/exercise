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
Config file    : **/etc/redis/6379.conf**
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

Redis database is not an equivalent(等同于) of database names in DBMS like mysql. It is a way to create isolation and namespacing for the keys, and only provides index based naming, not custom names like my_database.

By default, redis has **0-15** indexes for databases, you can change that number databases NUMBER in **redis.conf**.

##List All Redis Databases
There is no command to do it (like you would do it with MySQL for instance). The number of Redis databases is fixed, and set in the configuration file. By default, you have 16 databases (0-15). Each database is identified by a number (not a name).

redis-cli
##127.0.0.1:6379> CONFIG GET databases
You can use the following command to list the databases for which some keys are defined:
##127.0.0.1:6379> INFO keyspace
##127.0.0.1:6379> INFO

##redis-cli INFO | grep ^db
db0:keys=6,expires=0,avg_ttl=0


127.0.0.1:6379> select 2
OK
127.0.0.1:6379[2]> dbsize
(integer) 1
127.0.0.1:6379[2]> select 0
OK
127.0.0.1:6379> dbsize
(integer) 503

Continuous stats mode
##redis-cli --stat

Scanning for big keys
##redis-cli --bigkeys

Getting a list of keys
$ redis-cli --scan | head -10

$ redis-cli --scan --pattern '*-11*'
key-114
key-117
key-118
key-113
key-115
key-112

$ redis-cli --scan --pattern 'user:*' | wc -l
3829433


Monitoring commands executed in Redis
$ redis-cli monitor

Monitoring the latency of Redis instances
$ redis-cli --latency

Remote backups of RDB files
$ redis-cli --rdb /tmp/dump.rdb
SYNC sent to master, writing 13256 bytes to '/tmp/dump.rdb'
Transfer finished with success.

Retrieving All Existing Keys
127.0.0.1:6379> KEYS *

> SET title "The Hobbit"
OK
> SET author "J.R.R. Tolkien"
OK
> GET title
"The Hobbit"
> GET author
"J.R.R. Tolkien"

> SET title:1 "The Hobbit"
OK
> SET author:1 "J.R.R. Tolkien"
OK
> SET title:2 "The Silmarillion"
OK
> SET author:2 "The Silmarillion"
OK

> GET title:1
"The Hobbit"
> GET title:2
"The Silmarillion"

> KEYS *title*
1) "title:1"
2) "title:2"
3) "title"

# app/models/category.rb

class Category
  #...........
  after_save :clear_cache

  def clear_cache
    $redis.del "categories"
  end
  #...........
end

You should probably be using something like **cache_observers** in production, but for brevity sake we will stick with after_save here. In case you’re not sure which approach might work best for you

##Redis only stores strings as values. If you want to store an object, you can use a serialization mechanism such as JSON:
require "json"
redis.set "foo", [1, 2, 3].to_json
# => OK
JSON.parse(redis.get("foo"))
# => [1, 2, 3]






















