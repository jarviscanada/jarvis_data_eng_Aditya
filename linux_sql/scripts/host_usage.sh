#!/bin/bash



psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5


memory_free=$(echo "$(cat /proc/meminfo)"  | egrep "^MemFree: " | awk '{print $2/1000}' | xargs)
cpu_idle=$(echo "$(vmstat -t)"  | egrep "1" | awk '{print $15}' | xargs)
cpu_kernel=$(echo "$(vmstat -t)"  | egrep "1" | awk '{print $14}' | xargs)
disk_io=$(echo "$(vmstat -d)"  | egrep "1" | awk '{print $10}' | xargs)
disk_available=$(echo "$(vmstat -t)"  | egrep "1" | awk '{print $4/1000}' | xargs)
timestamp=$(echo "$(vmstat -t)"  | egrep "1" | awk '{print $18, $19}' | xargs)



insert_stmt="INSERT INTO host_usage ( "timestamp", host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available) VALUES ('${timestamp}', (SELECT id FROM host_info), ${memory_free}, ${cpu_idle} , ${cpu_kernel}, ${disk_io}, ${disk_available});"

psql -h "$psql_host" -p $psql_port -U "$psql_user" -d "$db_name" -c "$insert_stmt"

exit $?