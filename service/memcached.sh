#!/bin/sh
#
# memcached    Startup script for memcached processes
#
# chkconfig: - 90 10
# description: Memcache provides fast memory based storage.
# processname: memcached

# These mappings correspond one-to-one with Drupal's settings.php file.

PATH=/usr/local/memcached/bin:/sbin:/bin:/usr/sbin:/usr/bin

prog="/usr/local/memcached/bin/memcached"
[ -f $prog ] || exit 0

start() {
    echo -n $"Starting $prog "
    # Sessions cache.
    #memcached -m 16 -l 127.0.0.1 -p 11218 -d -u nobody
    # Default cache.
    #memcached -m 32 -l 127.0.0.1 -p 11212 -d -u nobody
    # Block cache.
    #memcached -m 32 -l 127.0.0.1 -p 11213 -d -u nobody
    # Content cache. Holds fully loaded content type structures.
    #memcached -m 16 -l 127.0.0.1 -p 11214 -d -u nobody
    # Filter cache. Usually the busiest cache after the default.
    #memcached -m 32 -l 127.0.0.1 -p 11215 -d -u nobody
    # Form cache.
    #memcached -m 32 -l 127.0.0.1 -p 11216 -d -u nobody
    # Menu cache.
    #memcached -m 32 -l 127.0.0.1 -p 11217 -d -u nobody
    # Page cache. Bigger than most other caches.
    $prog -m 128 -l 127.0.0.1 -p 11211 -d -u nobody -P /var/run/memcached/memcached.pid -c 1024
    RETVAL=$?
    echo
    return $RETVAL
}

stop() {
    if test "x`pidof memcached`" != x; then
        echo -n $"Stopping $prog "
        killall memcached
        echo
    fi
    RETVAL=$?
    return $RETVAL
}

case "$1" in
		start)
				start
				;;

		stop)
				stop
				;;

		restart)
				stop
				start
				;;
		condrestart)
				if test "x`pidof memcached`" != x; then
				    stop
				    start
				fi
				;;

		*)
				echo $"Usage: $0 {start|stop|restart|condrestart}"
				exit 1
esac

exit $RETVAL

