select *
FROM (SELECT
    host_info.cpu_number AS cpu_number,
    host_info.id as host_id,
    host_info.total_mem AS total_mem
    from host_info
    order by total_mem DESC) as c
GROUP BY c.cpu_number, c.host_id, c.total_mem;


SELECT
    u.host_id as host_id,
    i.hostname as host_name,
    date_trunc('hour', u."timestamp") + date_part('minute', u."timestamp")::int / 5 * interval '5 min' as times,
    (((i.total_mem-u.memory_free)*100/i.total_mem)) as average_mem
FROM host_usage u, host_info i
WHERE u.host_id = i.id;


