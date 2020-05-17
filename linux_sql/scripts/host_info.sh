#!/bin/bash

psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5
hostname=$(hostname -f)
lscpu_out=`lscpu`

cpu_number=$(echo "$lscpu_out"  | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
cpu_number=$(echo "$lscpu_out"  | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
cpu_architecture=$(echo "$lscpu_out" | egrep "^ARCHITECTURE:" | awk '{print $2}' | xargs)
cpu_model=$(echo "$lscpu_out" | egrep "^Model name:" | awk '{print $3, $4, $5, $6, $7}' | xargs)
cpu_mhz=$(echo "$lscpu_out" | egrep "^CPU MHz:" | awk '{print $3}' | xargs)
l2_cache=$(echo "$lscpu_out" | egrep "^L2 cache:" | awk '{print $3}' | grep -o -E '[0-9]+' | awk '{print $1}' | xargs)
total_mem=$(echo "$(cat /proc/meminfo)" | egrep "^MemTotal:" | awk '{print $2}' | xargs)
timestamp=$(echo "$(vmstat -t)"  | egrep "1" | awk '{print $18, $19}' | xargs)
insert_stmt="INSERT INTO host_info (hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, L2_cache, total_mem, "timestamp") VALUES ('${hostname}',${cpu_number},'${cpu_architecture}', '${cpu_model}', ${cpu_mhz}, ${l2_cache}, ${total_mem}, '${timestamp}');"
psql -h "$psql_host" -p "$psql_port" -U "$psql_user" -d "$db_name" -c "$insert_stmt"
exit $?