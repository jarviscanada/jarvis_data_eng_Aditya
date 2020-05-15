#!/bin/bash

#bash scripts/host_usage.sh psql_host psql_port db_name psql_user psql_password
#
## Example
#bash scripts/host_usage.sh localhost 5432 host_agent postgres password

psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5
#pseudo code
#- parse server CPU and memory usage data using bash scripts
memory_free=$(echo "$(cat /proc/meminfo)"  | egrep "^MemFree: " | awk '{print $2/1000}' | xargs)
cpu_idle=$(echo "$(vmstat -t)"  | egrep "1" | awk '{print $15}' | xargs)
cpu_kernel=$(echo "$(vmstat -t)"  | egrep "1" | awk '{print $14}' | xargs)
disk_io=$(echo "$(vmstat -d)"  | egrep "1" | awk '{print $10}' | xargs)
disk_available=$(echo "$(vmstat -t)"  | egrep "1" | awk '{print $4/1000}' | xargs)
#- construct the INSERT statement. (hint: use a subquery to get id by hostname)
timestamp=$(echo "$(vmstat -t)"  | egrep "^ 0 " | awk '{print $18, $19}' | xargs)



insert_stmt = INSERT INTO host_usage ("timestamp", host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_avaiable) VALUES ('${timestamp}', SELECT MAX(id) FROM host_info;, ${memory_free}, ${cpu_idle} , ${cpu_kernel}, ${disk_io}, ${disk_avaiable} )

psql -h "$psql_host" -p $psql_port -U "$psql_user" -d "$db_name" -c $insert_stmt