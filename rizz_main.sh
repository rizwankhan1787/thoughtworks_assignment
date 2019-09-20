#!/bin/bash
# Setup my twip environemt
pn=rizz_tweak

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Run this section if docker is not installed
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# check for pre-reqs
if [ ! -x "$(which docker)" ]; then
     
    echo Check/Installing docker
    
     [ ! -x "$(which docker)" ] && yum install -y docker && service docker start
   
    echo "Check/Installing certbot ssl certificate"
     
    [ ! -x "$(which docker)" ] && yum install python27-devel -y && git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt && /opt/letsencrypt/letsencrypt-auto --debug && echo "rsa-key-size = 4096" >> /etc/letsencrypt/config.ini && echo "email = rizwankhan1787@gmail.com" >> /etc/letsencrypt/config.ini && /opt/letsencrypt/letsencrypt-auto certonly --debug --webroot -w /var/www/_us-east-2.compute.amazonaws.com -d us-east-2.compute.amazonaws.com  --config /etc/letsencrypt/config.ini --agree-tos 
    

        
    # Now lets get docker compose
    echo Check/Installing docker-compose
    dc=$(which docker-compose)

    if [ $? -ne 0 ]; then
        curl -L https://github.com/docker/compose/releases/download/1.7.0/docker-compose-`uname -s`-`uname -m` > docker-compose
        chmod +x docker-compose
        sudo mv docker-compose /usr/local/bin/docker-compose
    fi
    
    # and finally docker machine
    echo Check/Installing docker-machine
    dc=$(which docker-machine)
    
    if [ $? -ne 0 ]; then
        curl -L https://github.com/docker/machine/releases/download/v0.6.0/docker-machine-`uname -s`-`uname -m` > docker-machine
        chmod +x docker-machine
        sudo mv docker-machine /usr/local/bin/docker-machine
    fi 
    
fi

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# helper functions 

# a little clean up function
cleanup(){
    docker rm $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
    docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Help 
if [ $# -lt 1 ] || [ "$1" = "help" ]; then
   echo
   echo "$pn usage: command [arg...]"
   echo
   echo "Commands:"
   echo
   echo "rizz_uat      Creates the environment"
   echo "rizz_sit       Creates the production environment"
   echo "pack       Tag and push production images"
   echo "status     Display the status of the environment"
   echo "test       Quick test - header info only" 
   echo "clean      Removes dangling images and exited containers"
   echo "images     List images"
   echo
   exit
fi 

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# training
if [ "$1" = "rizz_uat" ]; then
	if [ $# -lt 2 ]; then
        echo
        echo "usage : $pn $1 [ build | up | down ]"
    else
        cd $1
            cmd="$2"
            if [ "$2" = "build" ]; then docker build -t rizz_uat rizz_web ./tomcat;fi
            if [ "$2" = "up" ]; then cmd="up -d";fi;
            docker-compose $cmd $3 $4
            if [ "$2" = "build" ]; then echo;docker images
            else echo;docker-compose ps;fi        
        cd ..
    fi
	echo
    exit
fi    	

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# prod
if [ "$1" = "prod" ]; then
	if [ $# -lt 2 ]; then
        echo
        echo "usage : $pn $1 [ build | up | down ]"
    else
        cd $1
            cmd="$2"
            if [ "$2" = "up" ]; then cmd="up -d";fi;
            docker-compose $cmd $3 $4
            if [ "$2" = "build" ]; then docker pull dockercloud/haproxy:1.2.1;echo;docker images
            else echo;docker-compose ps;fi        
        cd ..
    fi
	echo
    exit
fi  

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# status
if [ "$1" = "status" ]; then
    env | grep DOCKER
    docker ps -a
	echo;exit
fi      	

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# pack
if [ "$1" = "pack" ]; then
    docker tag prod_static rizz/companystatic
    docker tag prod_web rizz/companyweb
    docker push codemarc/companystatic
    docker push codemarc/companyweb
	echo;exit
fi

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# test
if [ "$1" = "test" ]; then
    echo curl -I -X GET http://localhost/
    curl -I -X GET http://localhost/$2
	echo;exit
fi

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# bench
if [ "$1" = "bench" ]; then
    echo ab -n 1000 -c 10 http://localhost/
    ab -n 1000 -c 10 http://localhost/
	echo;exit
fi
      	
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# images
if [ "$1" = "images" ]; then
    docker images
	echo;exit
fi    	

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# clean
if [ "$1" = "clean" ]; then
	if [ "$2" = "all" ]; then docker rmi $(docker images -q)
    elif [ "$2" = "up" ]; then cleanup
    else
        echo
        echo "usage : $pn clean [ up | all ]";
	fi
	echo;exit;	
fi;

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Unknown
echo
(>&2 echo $pn: UNKNOWN COMMAND [\"$1\"])
$0 help
exit

