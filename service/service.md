##su - postgres
##/usr/local/pgsql/bin/postmaster -D /usr/local/pgsql/data >logfile 2>&1 &

bundle exec puma -C /home/simon/exercise/config/puma.rb  -e production -p 3000 --daemon -b unix:///tmp/exercise_puma.sock
ps aux | grep puma

##bundle exec unicorn -c /home/simon/exercise/config/unicorn.rb -E development  -p 3000 -D

cd /usr/local/nginx/sbin
sudo ./nginx -c /home/simon/exercise/config/nginx.cnf

ps x | awk '/[^\]]nginx: master/ {print $1}' | xargs kill
#or use follow line to kill the thread
#killall -u $USER -v -i nginx


#在 netstat 输出中显示 PID 和进程名称 netstat -p
netstat -pt 可以与其它开关一起使用，就可以添加 “PID/进程名称” 到 netstat 输出中，这样 debugging 的时候可以很方便的发现特定端口运行的程序。
#netstat -pt|grep unicorn

#找出运行在指定端口的进程
netstat -an | grep ':80'

#先把状态全都取出来,然后使用uniq -c统计，之后再进行排序。
netstat -nat |awk '{print $6}'|sort|uniq -c|sort -rn

#分析development.log获得访问前10位的ip地址
awk '{print $1}' development.log |sort|uniq -c|sort -nr|head -10

#netstat -ie =>ifconfig


##rake db:create RAILS_ENV=production
##rails s -e production 
##(bundle exec) rake assets:precompile RAILS_ENV=production
##rails c production
##rails runner script/load_products.rb -e production


##puma cluster 100% cpu usage

##sudo service unicorn_exercise start
##sudo service nginx start

#sudo service redis_6379 start
#sudo service redis_6379 stop
#sudo service redis_6379 status


##Create a new repository
Just go to Github, create a new repo, it will ask you to add a README, don't add it. Create it, and you'll get instructions on how to push.

cd exercise
git init
git remote add origin git@github.com:tongxm520/exercise.git
git add .
git commit -am "all code"
git push origin master

##run in development
cap unicorn:stop
sudo service unicorn_exercise start

cap nginx:stop
rake nginx:setup
sudo service nginx start

##run in production
cap deploy
cap deploy:setup
cap -T

sudo service unicorn_exercise stop
cap unicorn:start

sudo service nginx stop
cap nginx:start




