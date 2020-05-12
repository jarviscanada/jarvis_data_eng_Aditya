#!/bin/bash

#script pseudocode
#hint: `systemctl status docker || ...`
#if docker_deamon is not running
#	start docker_deamon
docker_command=$1
db_username=$2
db_password=$3

#systemctl status docker || systemctl start docker


if [ $docker_command == "create" ];then

  #hint `docker container ls -a -f name=jrvs-psql | wc -l` should be 2
  if [[ $(docker container ls -a -f name=jrvs-psql) == 2 ]]; then
    print "docker container already exists" #error and usage
    exit 1
  fi


  if [[ $db_username == "" || $db_password == "" ]];then
    echo "db_username or db_password not entered"
    exit 1
  fi



  #hint: `docker volume create ...`
  docker volume create pgdata
#  create `pgdate` volume
  #hint: `docker run --name jrvs-psql -e POSTGRES_PASSWORD=${db_password} -e POSTGRES_USER=${db_username} -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres`
  docker run --name jrvs-psql -e POSTGRES_PASSWORD=${db_password} -e POSTGRES_USER=${db_username} -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres
# create a psql container
  #What's $? variable? https://bit.ly/2LanHUi
  exit 0
fi

if [[ $(docker container ls -a -f name=jrvs-psql) == "" ]];then
  echo "jarvs-psql not created"
  exit 1
fi

if [ $docker_command == "start" ]; then
  docker container start jrvs-psql
  exit 0
fi
if [ $docker_command == "stop" ];then
  docker container stop jrvs-psql
  exit 0
fi

if [[ $docker_command != "create"  ||  $docker_command != "start"  ||   $docker_command != "stop" ]];then
  echo "invaild input given"
  exit 1
fi
