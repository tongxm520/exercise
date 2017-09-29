##cd memcached-1.4.34/
##./configure --prefix=/usr/local/memcached

checking for libevent directory... configure: error: libevent is required
wget https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
tar -zxvf libevent-2.1.8-stable.tar.gz
cd libevent-2.1.8-stable
./configure
make
sudo make install

Libraries have been installed in: /usr/local/lib


##make 
##make test 
##sudo make install




