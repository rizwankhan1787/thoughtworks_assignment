# ThoughWorks Assignment #


### Problem Statement
> A development team has created a Java web app that is ready for a limited 
release (with reduced availability and reliability requirements).  If the 
limited release is successful, the app will be rolled out for worldwide use. 
Once fully public, the application needs to be available 24/7 and must provide 
sub-second response times and continuity through single-server failures.
 

  
Design and create the environments, and provide a plan to 
scale out that deployment when the application goes public.


### Assumptions
* The development team has a continuous integration build that produces two artifacts:
  * a .zip file static.zip with the image and 
  stylesheet used for the application
  * a .war file companyNews.war with the dynamic parts of the application
  
* we should deploy the static assets to a web server and the .war file to a separate application server. 

* The app (companyNews) uses Prevayler for persistence. Prevayler essentially persists data to a file. The dev team chose this to simplify the development effort, rather than having to deal with an RDBMS.

### Solution Strategy

There is a set of principles about to follow when a working on problem set like this. 
Create infrastructure that is flexible, automatic, consistent, reproducible,
and disposable. The problem feels like it was custom made for a **container** solution.
And today that means **Docker**.  

The full set of the technologies selected for this project are broken down as follows

#### Tools Environment
These tools are used to host, build, test and run the infrastructure components
- Amazon Linux 
  - Muzzu_Environment Amazon Web Services [EC2](https://aws.amazon.com/ec2/), [EC2 Container Service](https://aws.amazon.com/ecs/)
- [Docker Hub](https://hub.docker.com/) and [Docker Toolbox](https://www.docker.com/products/docker-toolbox) including 
  - [docker engine](https://www.docker.com) 
  - [docker-compose](https://www.docker.com/products/docker-compose) 
  - [docker-machine](https://www.docker.com/products/docker-machine)
  - [docker-swarm](http://www.docker.com/products/docker-swarm)
  
- [Git 1.9.1](https://git-scm.com/) And [GitHub](https://github.com/)

#### Application Environment
These software components are used to logically run the application 

- [Alpine Linux 3.3](https://www.alpinelinux.org/)
- [NGINX 1.9.15](https://www.nginx.com/)
- [OpenJDK]
- [Apache Tomcat ]

## Platform


### AWS EC2  

spinning up a brand spanking new EC2 t2.micro instance, running 
Amazon Linux. 
Security Group :
22
443
80
31000 - 33000/tcp.
5600-5900/tcp.



### Docker Machine
docker machine
as it provides the ability to provision and manager virtual machines with an installed
and running docker engine.


<br/><hr/>
## Source 

The source for this project is currently stored on GitHub. In order to easily and more importantly 
get the source you need a git client installed on your virtual machine. 

#### Getting the source
1. ssh to your host
1. install git

$ yum install git -y


$ git clone https://github.com/rizwankhan1787/thoughtworks_assignment.git
Cloning into 'thoughtworks_assignment'...
remote: Counting objects: 4, done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 4 (delta 0), reused 4 (delta 0), pack-reused 0
Unpacking objects: 100% (4/4), done.
Checking connectivity... done.
```

### Installing preqs 




###Create Certbot SSL Certificates

The Install
1. Install Python:
$ yum install python27-devel git
2. Install Let’s Encrypt by cloning the github repository into /opt/letsencrypt and running the Let’s Encrypt installer:
$ git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt$ /opt/letsencrypt/letsencrypt-auto --debug
2a. If you’re running Amazon Linux 2 on your EC2 follow these additional steps (thanks @andrenakkurt!) before continuing.
3. Make a configuration file (/etc/letsencrypt/config.ini) that will be used to sign all future certificates and renewals with your private key and email address:
$ echo "rsa-key-size = 4096" >> /etc/letsencrypt/config.ini$ echo "email = ________@____.com" >> /etc/letsencrypt/config.ini
Certificate Generation
1. Request a certificate the naked domain (_______.com) and www subdomain (www._______.com), using a “secret file” generated in a directory (.well-known) in your website’s root folder (/var/www/_______)
$ /opt/letsencrypt/letsencrypt-auto certonly --debug --webroot -w /var/www/_______ -d _______.com -d www._______.com --config /etc/letsencrypt/config.ini --agree-tos 
Certificate files (cert.pem, chain.pem, fullchain.pem, and privkey.pem) are generated in an individual folder for each domain in /etc/letsencrypt/live/ (e.g. /etc/letsencrypt/live/_______.com/ )
•	cert.pem: server certificate only.
•	chain.pem: root and intermediate certificates only.
•	fullchain.pem: combination of server, root and intermediate certificates (replaces cert.pem and chain.pem).
•	privkey.pem: private key (do not share this with anyone!).
Take a note of your expiration date and other important information displayed on the confirmation screen.
2. Remove the now-empty “secret file” directory, if desired (for cleanliness)
$ rmdir /var/www/______/.well-known




Install the Pre-requisites against the environment




$cd tw_assignment
$ chmod +x 

$ ./rizz_main.sh

the above script will checks for and installs 
[docker](https://www.docker.com), 
[docker-compose](https://www.docker.com/products/docker-compose), 
[docker-machine](https://www.docker.com/products/docker-machine), and  
 



After you log back in and cd tw_assignment  and run muzzu_master.sh
```bash
$ cd  thoughtworks_assignment && ./rizz_main.sh

rizz usage: command [arg...]

Commands:

rizz_uat      Creates the muzzu_uating environment
prod       Creates the production environment
pack       Tag and push production images
status     Display the status of the environment
bench      Run Benchmarking Tests
clean      Removes dangling images and exited containers
images     List images
```

<br/><hr/>
## rizz_uat
Package the static assets into a container running [NGINX](https://www.nginx.com/) and package the app 
on into a container running tomcat
<div style="text-align:center;margin:3em;">
<img src='https://raw.githubusercontent.com/codemarc/twip/master/img/rizz_uat.png' width='80%'/>  
</div>


##### NGINX for proxy and hosting static assets
[NGINX](https://www.nginx.com/) is a web server, a load balancer, 
a content cache and more. I am by no means an NGINX expert but I have 
been using it more and more lately and I find it to be a very effective 
tool in the container world. It is modular in nature and is a little 
easier configure to understand then Apache, and if configured appropriately
is blazingly fast.  


##### Apache Tomcat
Tomcat  is another web server that is 
able to serve static and/or dynamic content either from a standalone or embedded 
instantiations.In this project we used tomcat strictly as a servlet container for
the dynamic part of the application.

.

### docker-compose.yml

The *
* shell script is yet another wrapper for yet another markup language.
In this case docker-compose. The script below is used to describe the muzzu_uating environment
in terms of docker-compose.

```
version: '2'

services:
  static:
    build: nginx/
    ports:
    - 80:80
    networks:
    - net
    depends_on:
    - app
    hostname: static
    container_name: static
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock

  web1:
    build: tomcat/
    ports:
    - 8080
    networks:
    - net
    hostname: web1
    volumes:
      - ../data:/user/data/persistence
      
  web2:
    build: tomcat/
    ports:
    - 8080
    networks:
    - net
    hostname: web2
    volumes:
      - ../data:/user/data/persistence

  elk:
    image: sebp/elk:latest
    ports:
    - 5601:5601
    - 9200:9200
    - 5044:5044
    - 5000:5000
    networks:
    - net
    volumes:
    - app_elk:/var/lib/elasticsearch
    hostname: elk
    container_name: elk

volumes:
  app_elk:
    external: true

networks:
  net:
    driver: bridge
```


<br/><br/>

### Build the rizz_uating containers

The included script *./rizz_main.sh* simplifies the process of building and running
the environment. It is yet another wrapper on top of the docker tools to help 
reduce command line fat finger ~~mistakes~~.


````bash
$ ./rizz_main.sh images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE

$ ./rizz_main.sh muzzu_uat build
.
.
.
Successfully built 0200e8810fbd
REPOSITORY              TAG                 IMAGE ID            CREATED             SIZE
train_static            latest              d6851e2cbbcb        23 hours ago        157MB
train_web               latest              3abf547e83fd        24 hours ago        502MB
music_app               latest              268c0ba7868a        2 days ago          526MB
nginx                   latest              f68d6e55e065        3 days ago          109MB
sebp/elk                latest              0c1a88826f47        9 days ago          1.93GB
tomcat                  8.5.38-jre8         02eaee4dc65c        3 months ago        463MB
````

* When constructing a container based infrastructure it is important to be mindful of image 
size. I believe that larger containers include more technical debt. Alpine Linux + nginx is billed 
as a security-oriented, lightweight Linux distribution. If we can construct all out containers based on the same underpinnings then we will have a cleaner and consistent environment.



 
### Run rizz_uating
To spin up the muzzu_uating environment you can run *muzzu_master.sh* as follows:  

````bash
$ ./rizz_main.sh rizz_uat up
Starting web1
Starting web2
Starting elk
Starting static

      Name             Command             State              Ports       
-------------------------------------------------------------------------
elk                /usr/local/bin/s   Up                 0.0.0.0:5000->50 
                   tart.sh                               00/tcp, 0.0.0.0: 
                                                         5044->5044/tcp,  
                                                         0.0.0.0:5601->56 
                                                         01/tcp, 0.0.0.0: 
                                                         9200->9200/tcp,  
                                                         9300/tcp         
static             /usr/local/bin/s   Up                 0.0.0.0:80->80/t 
                   tart.sh                               cp               
web1               /usr/local/bin/s   Up                 0.0.0.0:32768->8 
                   tart.sh                               080/tcp          
web2               /usr/local/bin/s   Up                 0.0.0.0:32769->8 
                   tart.sh                               080/tcp   
And run a few quick test
````bash


$ ./rizz_main.sh test
curl -I -X GET http://localhost/
HTTP/1.1 200 OK
Server: nginx/1.9.15
Date: Sun, 7 July 2019 21:16:50 GMT
Content-Type: text/html;charset=ISO-8859-1
Content-Length: 331
Connection: keep-alive
Set-Cookie: JSESSIONID=1uymgnsr4edtx1ue20vl1n4p7w;Path=/
Expires: Thu, 01 Jan 1970 00:00:00 GMT
Request-Time: 0.002
Upstream-Address: 172.18.0.2:8080
Upstream-Response-Time: 1462915010.123

$ ./muzzu_master.sh test Read.action
curl -I -X GET http://localhost/Read.action
HTTP/1.1 200 OK
Server: nginx/1.9.15
Date: Sun, 7 July 2019 21:20:30 GMT
Content-Type: text/html;charset=ISO-8859-1
Content-Length: 799
Connection: keep-alive
Set-Cookie: JSESSIONID=10ekx3h62qoi5c5n1hqf87448;Path=/
Expires: Thu, 01 Jan 1970 00:00:00 GMT
Request-Time: 0.026
Upstream-Address: 172.18.0.2:8080
Upstream-Response-Time: 1462915230.715

$ ./rizz_main.sh rizz_uat down
Stopping static_1 ... done
Stopping web1_1 ... done
Stopping web2_1 ... done
Removing static_1 ... done
Removing web1_1 ... done
Removing web2_1 ... done
Removing network default

Name   Command   State   Ports 
------------------------------

$ ./muzzu_master.sh test
curl -I -X GET http://localhost/
curl: (7) Failed to connect to localhost port 80: Connection refused

````

### Benchmarking the rizz_uating environment
if you have installed Apache Bench to do some simple benchmarking. The muzzu_master.sh bench command 
runs ab apache bench, 1000 HTTP requests, 10 at a time to check how well our infrastructure standsup.
  
 `$ ab -n 1000 -c 10 http://localhost/`  
  
> $ ./rizz_main.sh bench

````bash
$ ab -n 1000 -c 10 http://localhost/
This is ApacheBench, Version 2.3 <$Revision: 1528965 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking localhost (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Completed 600 requests
Completed 700 requests
Completed 800 requests
Completed 900 requests
Completed 1000 requests
Finished 1000 requests


Server Software:        nginx/1.9.15
Server Hostname:        localhost
Server Port:            80

Document Path:          /
Document Length:        331 bytes

Concurrency Level:      10
Time taken for tests:   0.815 seconds
Complete requests:      1000
Failed requests:        0
Total transferred:      589914 bytes
HTML transferred:       331000 bytes
Requests per second:    1226.77 [#/sec] (mean)
Time per request:       8.151 [ms] (mean)
Time per request:       0.815 [ms] (mean, across all concurrent requests)
Transfer rate:          706.73 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.2      0       3
Processing:     2    8  10.9      6     183
Waiting:        0    8  10.9      6     182
Total:          2    8  10.9      6     183

Percentage of the requests served within a certain time (ms)
  50%      6
  66%      8
  75%      9
  80%      9
  90%     11
  95%     13
  98%     18
  99%     32
 100%    183 (longest request)
````

### Ups and Downs
The following tests illustrate behaviors of the rizz_uating environment
Starting with the state:
````bash
     Name                   Command               State              Ports            
-------------------------------------------------------------------------------------
static_1   /usr/local/bin/start.sh;             Up      443/tcp, 0.0.0.0:80->80/tcp 
web1_1     /usr/local/bin/start.sh...   Up      0.0.0.0:32784->8080/tcp     
web2_1     /usr/local/bin/start.sh...   Up      0.0.0.0:32783->8080/tcp     
````

>#### no webapps

````bash
$ ./rizz_main.sh rizz_uat scale web2=0
Stopping and removing web2_1 ... done

     Name                   Command               State              Ports            
-------------------------------------------------------------------------------------
 static_1   /usr/local/bin/start.sh;             Up      443/tcp, 0.0.0.0:80->80/tcp 
 web1_1     /usr/local/bin/start.sh...   Up      0.0.0.0:32784->8080/tcp
 
 $ ./rizz_main.sh rizz_uat scale web1=0
 stopping and removing web1_1 ... done

     Name              Command          State              Ports            
---------------------------------------------------------------------------
static_1   /usr/local/bin/start.sh;   Up      443/tcp, 0.0.0.0:80->80/tcp 

$ ./rizz_main.sh test
curl -I -X GET http://localhost/
HTTP/1.1 502 Bad Gateway
Server: nginx/1.9.15
Date: Sun, 7 July 2019 21:36:09 GMT
Content-Type: text/html
Content-Length: 537
Connection: keep-alive
ETag: "572cb9eb-219"     
````

>#### restore webapp

````bash
$ ./rizz_main.sh rizz_uat scale web1=1
Creating and starting web1_1 ... done

     Name                   Command               State              Ports            
-------------------------------------------------------------------------------------
static_1   /usr/local/bin/start.sh;             Up      443/tcp, 0.0.0.0:80->80/tcp 
web1_1     /usr/local/bin/start.sh...   Up      0.0.0.0:32785->8080/tcp     

$ ./rizz_main.sh test
curl -I -X GET http://localhost/
HTTP/1.1 200 OK
Server: nginx/1.9.15
Date: Sun, 7 July 2019 21:40:38 GMT
Content-Type: text/html;charset=ISO-8859-1
Content-Length: 331
Connection: keep-alive
Set-Cookie: JSESSIONID=zgmv7qbjbghdzm0o5mapcgda;Path=/
Expires: Thu, 01 Jan 1970 00:00:00 GMT
Request-Time: 1.083
Upstream-Address: 172.18.0.2:8080
Upstream-Response-Time: 1462916436.949
````

> #### scale up static assets

````bash
$ ./rizz_main.sh muzzu_uat scale static=2  
WARNING: The "static" service specifies a port on the host. If multiple containers for this service are created on a single host, the port will clash.
Creating and starting static_2 ... error

ERROR: for static_2  driver failed programming external connectivity on endpoint static_2 (c94a1180aa516d8f1f803c8145afc1719476b94c412c8ab77b29239d6fc3e736): Bind for 0.0.0.0:80 failed: port is already allocated

     Name                   Command                State                Ports            
----------------------------------------------------------------------------------------
static_1   /usr/local/bin/start.sh;             Up         443/tcp, 0.0.0.0:80->80/tcp 
static_2   /usr/local/bin/start.sh;             Exit 128                               
web2_1     /usr/local/bin/start.sh...   Up         0.0.0.0:32779->8080/tcp     
````

>#### no static assets

````bash
$ ./rizz_main.sh rizz_uat scale static=0

     Name                   Command                State              Ports          
------------------------------------------------------------------------------------
static_2   /usr/local/bin/start.sh;             Exit 128                           
web2_1     /usr/local/bin/start.sh...   Up         0.0.0.0:32779->8080/tcp

$ ./muzzu_master.sh test
curl -I -X GET http://localhost/
curl: (7) Failed to connect to localhost port 80: Connection refused 
````

### Take it down and clean it up

````bash
$ ./rizz_main.sh rizz_uat down
Stopping web2_1 ... done
Removing static_2 ... done
Removing web2_1 ... done
Removing network default
````

<hr/>


