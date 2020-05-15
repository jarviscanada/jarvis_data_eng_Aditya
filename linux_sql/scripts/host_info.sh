#!/bin/bash


# Script usage
./scripts/host_info.sh psql_host psql_port db_name psql_user psql_password

# Example
./scripts/host_info.sh "localhost" 5432 "host_agent" "postgres" "mypassword"

- assign CLI arguments to variables (e.g. `psql_host=$1`)
- parse host hardware specifications using bash cmds
- construct the INSERT statement
- execute the INSERT statement through psql CLI tool

psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

#save hostname to a variable
hostname=$(hostname -f)

#save number of CPU to a variable
lscpu_out=`lscpu`
#note: `xargs` is a trick to remove leading and trailing white spaces
cpu_number=$(echo "$lscpu_out"  | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)

#hardware
hostname=$(hostname -f)
echo"$hostname"
cpu_number=$(echo "$lscpu_out"  | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
cpu_architecture=$(echo "$lscpu_out" | egrep "^ARCHITECTURE:" | awk '{print $2}' | xargs)
cpu_model=$(echo "$lscpu_out" | egrep "^Model name:" | awk '{print $3, $4, $5, $6, $7}' | xargs)
cpu_mhz=$(echo "$lscpu_out" | egrep "^CPU MHz:" | awk '{print $3}' | xargs)
l2_cache=$(echo "$lscpu_out" | egrep "^L2 cache:" | awk '{print $3}' | xargs)
total_mem=$(echo "$(cat /proc/meminfo)" | egrep "^MemTotal:" | awk '{print $2}' | xargs)
timestamp=$(echo "$(vmstat -t)"  | egrep "^ 0 " | awk '{print $18, $19}' | xargs)

insert_stmt="INSERT INTO host_info (hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, L2_cache, total_mem, "timestamp") VALUES ('${hostname}',${cpu_number},'${cpu_architecture}', '${cpu_model}', ${cpu_mhz}, ${l2_cache}, ${total_mem}, '${timestamp}')

psql -h psHOST_NAME -p 5432 -U USER_NAME -d DB_NAME -c FILE_NAME.sql

psql -h "$psql_host" -p $psql_port -U "$psql_user" -d "$db_name" -c $insert_stmt