## /usr/local/pgsql/data/postgresql.conf

##sudo su - postgres
## /usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data >logfile 2>&1 &
## /usr/local/pgsql/bin/pg_ctl start -l logfile -D /usr/local/pgsql/data

~$ /usr/local/pgsql/bin/psql test
psql: could not connect to server: No such file or directory
        Is the server running locally and accepting
        connections on Unix domain socket "/var/run/postgresql/.s.PGSQL.5432"?

In Postgresql these terminal commands list the databases available
sudo -u postgres /usr/local/pgsql/bin/psql -h localhost --list

## sudo -u postgres /usr/local/pgsql/bin/psql test -h localhost -p 5432

sudo -u postgres /usr/local/pgsql/bin/psql exercise_dev -h localhost -p 5432
exercise_dev=# \list
exercise_dev=# \dt
exercise_dev=# SELECT * FROM products where id=1;
exercise_dev=# \d products

