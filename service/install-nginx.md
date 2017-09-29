# tar -zxvf nginx-1.10.3.tar.gz
# tar -zxvf nginx_upload_module-2.0.2.tar.gz
# tar -zxvf masterzen-nginx-upload-progress-module-v0.8.4-0-g82b35fc.tar.gz

Prior to compiling NGINX from the sources, it is necessary to install its dependencies:
1. the PCRE library – required by NGINX Core and Rewrite modules and provides support for regular expressions:
$ wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.41.tar.gz
$ tar -zxf pcre-8.41.tar.gz
$ cd pcre-8.41
$ ./configure
$ make
$ sudo make install

2. the zlib library – required by NGINX Gzip module for headers compression:
$ wget http://zlib.net/zlib-1.2.11.tar.gz
$ tar -zxf zlib-1.2.11.tar.gz
$ cd zlib-1.2.11
$ ./configure
$ make
$ sudo make install

3. the OpenSSL library – required by NGINX SSL modules to support the HTTPS protocol:
$ wget http://www.openssl.org/source/openssl-1.0.2k.tar.gz
$ tar -zxf openssl-1.0.2k.tar.gz
$ cd openssl-1.0.2k
$ ./configure darwin64-x86_64-cc --prefix=/usr
$ make
$ sudo make install

$ ./configure --sbin-path=/usr/local/nginx/nginx --conf-path=/usr/local/nginx/nginx.conf --pid-path=/usr/local/nginx/nginx.pid --with-http_ssl_module --with-stream --with-pcre=../pcre-8.41 --with-zlib=../zlib-1.2.11 --without-http_empty_gif_module

$ cd /home/simon/Downloads/stanford/nginx-1.10.3
$ ./configure --add-module=../nginx-upload-module-2.2 --add-module=../masterzen-nginx-upload-progress-module-82b35fc --with-http_ssl_module --with-stream
$ sudo make
$ sudo make install

##install nginx first
##when lack of dependencies install one by one



Before configuring Puma, you should look up the number of CPU cores your server has. You can easily to that with this command:

##grep -c processor /proc/cpuinfo

##To list only usernames type the following awk command:
##$ awk -F':' '{ print $1}' /etc/passwd

##https://www.digitalocean.com/community/tutorials/how-to-deploy-a-rails-app-with-puma-and-nginx-on-ubuntu-14-04
Create Puma Upstart Script	
cd ~
wget https://raw.githubusercontent.com/puma/puma/master/tools/jungle/upstart/puma-manager.conf
wget https://raw.githubusercontent.com/puma/puma/master/tools/jungle/upstart/puma.conf


nginx: error while loading shared libraries: libpcre.so.1: cannot open shared object file: No such file or directory

This generally happens due to following three reasons.
1. You don’t have PCRE installed
2. Nginx was not compiled & installed using pcre
3. PCRE library is not set in LD_LIBRARY_PATH

sudo find / -name libpcre.so.1 -type l
/usr/local/lib/libpcre.so.1

Now, let’s set LD_LIBRARY_PATH as we could see libpcre.so.1 is available under /usr/local/lib
export LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib:$LD_LIBRARY_PATH

ldconfig -p | grep "libpcre.so.1"

nginx -c /home/simon/exercise/config/nginx.cnf
nginx: [emerg] host not found in upstream "puma" in /home/simon/exercise/config/nginx.cnf:44
=>upstream exercise_puma {}

which nginx

You can simply fix all these with the following commands from the terminal:
cd /lib/i386-linux-gnu
fix=>sudo ln -s /usr/local/lib/libpcre.so.1 libpcre.so.1

##The nginx: unrecognized service error means the startup scripts need to be created. 
The nginx: unrecognized service error means the startup scripts need to be created.
Fortunately the startup scripts have already been written.

We can fetch them with wget and set them up following these steps:

# Download nginx startup script
wget -O init-deb.sh http://library.linode.com/assets/660-init-deb.sh

## Options to pass to nginx - manual config location (see then nginx wiki for more options)
DAEMON_OPTS="-c /home/simon/exercise/config/nginx.cnf"

# Move the script to the init.d directory & make executable
sudo mv init-deb.sh /etc/init.d/nginx (nginx is a file)
sudo chmod +x /etc/init.d/nginx

# Add nginx to the system startup
sudo /usr/sbin/update-rc.d -f nginx defaults
Now we can control nginx using:

sudo service nginx stop 
sudo service nginx start 
sudo service nginx restart
sudo service nginx reload

##Create Unicorn Init Script
sudo cp unicorn_exercise /etc/init.d/unicorn_exercise
sudo chmod 755 /etc/init.d/unicorn_exercise
sudo /usr/sbin/update-rc.d unicorn_exercise defaults

sudo service unicorn_exercise start

