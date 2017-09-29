https://ftp.postgresql.org/pub/source/v9.5.4/postgresql-9.5.4.tar.gz
tar -zxvf postgresql-9.5.4.tar.gz
cd postgresql-9.5.4
./configure
sudo make
sudo make install

Create postgreSQL user account=>
sudo adduser postgres
password:admin123

Create postgreSQL data directory=>
sudo mkdir /usr/local/pgsql/data
sudo chown postgres:postgres /usr/local/pgsql/data
ls -ld /usr/local/pgsql/data

Initialize postgreSQL data directory=>
su - postgres
/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data/

########################################################
WARNING: enabling "trust" authentication for local connections
You can change this by editing pg_hba.conf or using the option -A, or
--auth-local and --auth-host, the next time you run initdb.

Success. You can now start the database server using:

/usr/local/pgsql/bin/pg_ctl -D /usr/local/pgsql/data/ -l logfile start
########################################################

Validate the postgreSQL data directory=>
ls -l /usr/local/pgsql/data

Start postgreSQL database=>
Use the postgres postmaster command to start the postgreSQL server in the background as shown below.

su - postgres
/usr/local/pgsql/bin/postmaster -D /usr/local/pgsql/data >logfile 2>&1 &
=>[1] 15018

cat logfile=>
MultiXact member wraparound protections are now enabled
LOG:  database system is ready to accept connections
LOG:  autovacuum launcher started

ps -ef|grep postgres
postgres 14548  2178  0 16:41 pts/26   00:00:00 /usr/local/pgsql/bin/postmaster -D /usr/local/pgsql/data
kill -9 14548

Create postgreSQL DB and test the installation=>
Create a test database and connect to it to make sure the installation was successful as shown below. Once you start using the database, take backups frequently as mentioned in how to backup and restore PostgreSQL article.
http://www.thegeekstuff.com/2009/01/how-to-backup-and-restore-postgres-database-using-pg_dump-and-psql/

$ /usr/local/pgsql/bin/createdb test
$ /usr/local/pgsql/bin/psql test
test=# help

authentication and authorization
认证和授权
===================================================
Switch over to the postgres account on your server by typing:
sudo -i -u postgres
/usr/local/pgsql/bin/psql psql

Accessing a Postgres Prompt Without Switching Accounts
You can also run the command you'd like with the postgres account directly with sudo.
For instance, in the last example, we just wanted to get to a Postgres prompt. We could do this in one step by running the single command psql as the postgres user with sudo like this:

sudo -u postgres /usr/local/pgsql/bin/psql

switch to postgres
/usr/local/pgsql/bin/createuser --interactive
Enter name of role to add: sammy
Shall the new role be a superuser? (y/n) y
man createuser

CREATE TABLE playground (
    equip_id serial PRIMARY KEY,
    type varchar (50) NOT NULL,
    color varchar (25) NOT NULL,
    location varchar(25) check (location in ('north', 'south', 'west', 'east', 'northeast', 'southeast', 'southwest', 'northwest')),
    install_date date
);

We can see our new table by typing:
\d

Run a PostgreSQL .sql file using command line arguments=>
psql -U username -d myDataBase -a -f myInsertFile

psql -f file_with_sql.sql

\g or terminate with semicolon to execute query=>

postgres=# INSERT INTO playground (type, color, location, install_date) VALUES ('slide', 'blue', 'south', '2014-04-28') \g
postgres=# INSERT INTO playground (type, color, location, install_date) VALUES ('swing', 'yellow', 'northwest', '2010-08-16');

##########################################################
ou should take care when entering the data to avoid a few common hangups. First, keep in mind that the column names should not be quoted, but the column values that you're entering do need quotes.

Another thing to keep in mind is that we do not enter a value for the equip_id column. This is because this is auto-generated whenever a new row in the table is created.
##########################################################
postgres=# SELECT * FROM playground;

\list or \l: list all databases
\dt: list all tables in the current database

Besides using the \l command, you can use the SELECT statement to query database names from the pg_database catalog that stores data about all available databases.

SELECT datname FROM pg_database;
SELECT datname FROM pg_database WHERE datistemplate = false;

This lists tables in the current database=>
SELECT table_schema,table_name FROM information_schema.tables ORDER BY table_schema,table_name;

#######################################################
SELECT table_catalog,table_schema,table_name,table_type,is_insertable_into,is_typed FROM information_schema.tables WHERE table_type = 'BASE TABLE' AND table_schema = 'public' ORDER BY table_type, table_name;
#######################################################

If you want your user to connect to a different database, you can do so by specifying the database like this:

/usr/local/pgsql/bin/psql -d postgres
/usr/local/pgsql/bin/psql -d test
/usr/local/pgsql/bin/psql postgres
/usr/local/pgsql/bin/psql test

In Postgresql these terminal commands list the databases available
/bin/psql -h localhost --username=pgadmin --list

blog_development=# \d articles

###############################################################
su - postgres
/usr/local/pgsql/bin/postmaster -D /usr/local/pgsql/data >logfile 2>&1 &


netstat -an | grep 5432

could not connect to server no such file or directory postgres ubuntu
fix=>add <host: 127.0.0.1> to database.yml



