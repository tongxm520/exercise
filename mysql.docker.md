##What is a container image?

A container requires an image to run. A container image is like a virtual machine template. It has all the required stuff to run the container. That includes operating system, software packages, drivers, configuration files and helper scripts packed in one bundle.

When running MySQL on a physical host, here is what you would normally do:
1.  Prepare a host with proper networking
2.  Install operating system of your choice
3.  Install MySQL packages via package repository
4.  Modify the MySQL configuration to suit your needs
5.  Start the MySQL service

Running a MySQL Docker image would look like this:
1.  Install Docker engine on the physical host
2.  Download a MySQL image from public (Docker Hub) or private repository, or build your own MySQL image
3.  Run the MySQL container based on the image, which is similar to starting the MySQL service

As you can see, the Docker approach contains less deployment steps to get MySQL up and running. 99% of the time, the MySQL service running in container will usually work in any kind of environment as long as you have the Docker engine running. Building a MySQL container image requires process flow, since Docker expects only one process per container.
##########################################################

Downloading a MySQL Server Docker Image
##sudo docker pull mysql/mysql-server:tag
##sudo docker pull mysql/mysql-server:5.7
The tag is the label for the image version you want to pull (for example, 5.5, 5.6, 5.7, 8.0, or latest). If :tag is omitted, the latest label is used, and the image for the latest GA version of MySQL Community Server is downloaded. Refer to the list of tags for available versions on the mysql/mysql-server page in the Docker Hub. 


You can list downloaded Docker images with this command: 
##shell>sudo docker images

Start a new Docker container for the MySQL Community Server with this command:
##sudo docker run --name=mysql1 -d mysql/mysql-server:5.7

##sudo docker run --name mysqldb -e MYSQL_USER=mysql -e MYSQL_PASSWORD=mysql -d mysql/mysql-server:5.7

32 bit OS not support mysql/mysql-server:5.7
##########################################################

##sudo docker pull docker32/mysql:5.7

##sudo docker run --name=mysql1 -d docker32/mysql:5.7
docker mysql exited with code 1
sudo docker logs <CONTAINER ID>
sudo docker logs 918bda64aa5a

error: database is uninitialized and password option is not specified 
  You need to specify one of MYSQL_ROOT_PASSWORD, MYSQL_ALLOW_EMPTY_PASSWORD and MYSQL_RANDOM_ROOT_PASSWORD

##sudo docker run --name mysql1 -e MYSQL_ROOT_PASSWORD=admin123 -d docker32/mysql:5.7

<CONTAINER ID>
##sudo docker stop 77239bea2c7d
##sudo docker rm 77239bea2c7d


##sudo docker ps -a|grep mysql

docker mysql exited with code 1

sudo find / -name "my.cnf"
##/var/lib/docker/aufs/mnt/26a607219c3142693ee406b529cb5bce8c85062204f28a34fb02bb0ea6f781ea/etc/mysql/my.cnf

sudo find / -name "mysqld.sock"
sudo find / -name "mysqld.pid"
sudo find / -name "mysql" -type d


sudo mkdir -p /web/docker/mysql/logs
sudo mkdir -p /web/docker/mysql/pid
sudo mkdir -p /web/docker/mysql/data
sudo mkdir -p /web/docker/mysql/conf

##sudo docker run --name mysql1 -v /web/docker/mysql/conf:/etc/mysql/conf.d -v /web/docker/mysql/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=admin123  -d docker32/mysql:5.7

##sudo docker exec -it f22c8ebd7672 mysql -uroot -p

##sudo docker run --name mysql1 -v /web/docker/mysql/conf:/etc/mysql/conf.d -v /web/docker/mysql/pid:/var/run/mysqld -v /web/docker/mysql/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=admin123  -d docker32/mysql:5.7

##sudo docker run --name mysql1 -p 5000:3306 -v /web/docker/mysql/logs:/var/log/mysql/  -v /web/docker/mysql/conf:/etc/mysql/conf.d -v /web/docker/mysql/pid:/var/run/mysqld -v /web/docker/mysql/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=admin123  -d docker32/mysql:5.7

netstat -a|grep 5000

#比如保存成image: mysql:demo
#sudo docker commit 31e7c6ecdd60 mysql:demo
#下次启动的话就是
#sudo docker run -it mysql:demo

inspect commited images
##sudo docker images

##sudo docker rmi mysql:demo


