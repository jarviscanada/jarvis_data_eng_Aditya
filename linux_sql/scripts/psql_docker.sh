#!/bin/bash

docker_command=$1
db_username=$2
db_password=$3

systemctl status docker || systemctl start docker

if [ $docker_command == "create" ];then
  if [[ $(docker container ls -a -f name=jrvs-psql) == 2 ]]; then
    print "docker container already exists" #error and usage
    exit 1
  fi
  if [[ $db_username == "" || $db_password == "" ]];then
    echo "db_username or db_password not entered"
    exit 1
  fi
  docker volume create pgdata
  docker run --name jrvs-psql -e POSTGRES_PASSWORD=${db_password} -e POSTGRES_USER=${db_username} -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres
  exit $?
fi
#checking if container exists
if [[ $(docker container ls -a -f name=jrvs-psql) -ne 2 ]]; then
    print "docker container does not exists" #error and usage
    exit 1
fi
if [ $docker_command == "start" ]; then
  docker container start jrvs-psql
  exit $?
fi
if [ $docker_command == "stop" ];then
  docker container stop jrvs-psql
  exit $?
fi
echo "invaild input given"
exit 1
