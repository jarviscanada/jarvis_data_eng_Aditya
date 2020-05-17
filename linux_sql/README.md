# Linux Cluster Monitoring Agent
This project is under development. Since this project follows the GitFlow, the final work will be merged to the master branch after Team Code Team.
## Introduction
This project implements a way to check which computers are in a cluster and their usage. The infrastructure team can used the psql_docker to make a container in which they can keep the RDBMS tables of information for the multiple computers and their usage. Creating the DDL will help in creating the tables needed in the docker container in which the team can use to store the information. The monitoring agent will help them in gathering the cluster information through the use of Linux commands in bash scripts. This monitoring agent is critical to the team as it will provide the information for the computers in the cluster and their usage periodically using crontab, and with this information it can input such collected information to the tables in the docker container. All the scripts, bash or sql will help the infrastructure team determine which computers/nodes are on the cluster and how they are using the resources.

## Architecture and Design
![cluster diagram](./assets/cluster_diagram.jpg)

2) Describe tables

host_info: collect the information about the host in the cluster. Each host will be given a serial primary key and the host name will be unique. Other information collected would be cpu number, cpu architecture, cpu model, cpu mhz, L2 cache, total memory and timestamp of when the information is collected. This data will tell the information about the host from which the usage information was also collected.

host_usage: collected the resource information about the each host in the host table. Such information will be free memeory, idle cpu, cpu kernal, disk io, disk available and again a timestamp of when this information is collected. It will also have the host_id from the host_info table to figure out which host this information belongs to.

3) Describe scripts

psql_docker.sh: create/start/stop docker container that will hold the tables
ddl.sql: create the host info and usage tables
host_info.sh: collect host info and insert them into the host_info table
host_usage.sh: collect usage info and insert them into the host_usage table
queries.sql: run the queries on host_info and host_usage tables. These queries are such as ranking L2 cache in desending order grouped by cpu number and host id. The other query will figure out the average memory use of each host every 5 minutes.

## Usage
1) how to init database and tables

to create a database, run the following commands:
######connect to the psql instance
`psql -h localhost -U postgres -W`
######list all database
`postgres=# \l`
######create a database
`postgres=# CREATE DATABASE host_agent;`
######connect to the new database;
`postgres=# \c host_agent;`

to create tables, run the following command with appriopate values where needed:
`psql -h localhost -U postgres -W -d host_agent -f sql/ddl.sql`

2) `host_info.sh` usage
run the command in bash : `./scripts/host_info.sh psql_host psql_port db_name psql_user psql_password`

3) `host_usage.sh` usage
runt the command in bash: `bash scripts/host_usage.sh psql_host psql_port db_name psql_user psql_password`

4) crontab setup

use the following steps:
######edit crontab jobs
`bash> crontab -e`
######add this to crontab
`* * * * * bash /home/centos/dev/jrvs/bootcamp/linux_sql/host_agent/scripts/host_usage.sh localhost 5432 host_agent postgres password > /tmp/host_usage.log`


## Improvements 
1) write the query to be able to swithc to host_agent in ddl.sql
2) write the query to be able to get host node failure information in queries.sql
3) write better sql queries

