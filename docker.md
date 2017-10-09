################################################
x86_64 ==> 64-bit kernel
i686   ==> 32-bit kernel


install docker
Ubuntu 14.04 版本套件庫中已經內建了 Docker 套件，可以直接安裝。
$sudo apt-get install docker.io

$ sudo ln -sf /usr/bin/docker.io /usr/local/bin/docker
$ sudo sed -i '$acomplete -F _docker docker' /etc/bash_completion.d/docker
vi /etc/bash_completion.d/docker  G
$a=>append to the end of file

安裝之後啟動 Docker 服務。
$ sudo service docker start
$ sudo service docker stop
$ sudo service docker restart

The root account is disabled by default in Ubuntu, so there is no root password, that's why su fails with an authentication error.
Use sudo to become root:
##sudo -i

netstat -a|grep docker

$ sudo docker -d -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock &
$ sudo nohup docker -d -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock &

$ sudo docker info
$ sudo docker version
##FATA[0000] Get http:///var/run/docker.sock/v1.18/info: dial unix /var/run/docker.sock: no such file or directory. Are you trying to connect to a TLS-enabled daemon without TLS?
This error occurred because I didn't restart my computer after installing docker. Now the above command is working for me.

将镜像导入Docker
sudo cat ubuntu-14.04-x86-minimal.tar.gz | docker import - ubuntu:14.04
##dial unix /var/run/docker.sock: permission denied.

**sudo** cat ubuntu-14.04-x86-minimal.tar.gz |**sudo** docker import - ubuntu:14.04
82cba1cceb29320760e3a3640985c4f15774254c54782ccd86083bfd734f3141


运行ubuntu镜像
sudo docker run -it ubuntu:14.04 /bin/bash

With a name (let's use ubuntu):
$sudo docker run -i -t ubuntu:14.04 /bin/bash

Without a name, just using the ID:
$sudo docker run -i -t 82cba1cceb29 /bin/bash

#############################################################
##You cannot attach to a stopped container, start it first
$ sudo docker run -i -t -d 82cba1cceb29 /bin/bash
9a25696b1fdea8f200ba3488b46f8db8f776147993faa1fe2920bb54a3a0db06

sudo docker ps
CONTAINER ID   IMAGE  COMMAND  CREATED  STATUS PORTS   NAMES
9a25696b1fde 82cba1cceb29:latest   "/bin/bash"    37 seconds ago     Up 36 seconds       berserk_babbage 
$ sudo docker attach 9a25696b1fde

#############################################################
温馨提示：跑完的镜像记得保存其状态

#比如保存成image: ubuntu:demo
sudo docker commit container_id ubuntu:demo
#下次启动的话就是
#sudo docker run -it ubuntu:demo
#############################################################
First we’ll list which containers we have running:
##sudo docker ps

To list all local containers use -a option:
##sudo docker ps -a

It is some times handy to view the latest created container, including non-running containers. Simply use the -l option:
##sudo docker ps -l

Attach to a Specific Container
To attach to a specific container you must have the Container ID. In this case, we’ll attach to the container with the ID 9c09acd48a25 :
##sudo docker attach 9c09acd48a25

$ ID=$(sudo docker run -it -d ubuntu:14.04 /bin/bash -b)
$ sudo docker attach $ID
$ echo $ID
$ sudo docker stop $ID

cd docker/
Permission denied=>
##sudo chmod 755 -R docker/






