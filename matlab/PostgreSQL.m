
%% Jason-3文件验证数据

thr = get_Jason_3_Data_com('Jason-3');
Jason_lat = str2double(thr(:,1));
Jason_lon = str2double(thr(:,2));
Jason_swh = str2double(thr(:,3));
Jason_wind = str2double(thr(:,4));
Jason_time = thr(:,5);

%% 创建数据库连接

conn = database('postgres','postgres','742111', 'org.postgresql.Driver','jdbc:postgresql://localhost:5432/postgres');

% 检查连接状态
if isopen(conn)
    disp('数据库连接成功！');
else
    disp('数据库连接失败！');
end


% 准备要插入的数据
%geom = 'POINT(1.234 5.678)';
%swh = 1.23;
%watchtime = '2022-01-01 10:00:00';

% 构建插入语句
%insertQuery = sprintf("INSERT INTO public.Jason3_Point (geom, swh, watchtime) VALUES ('POINT(7.234 12.678)', 1.23, '2022-01-01 10:00:00')");

% 执行插入操作
%exec(conn, insertQuery);



for i = 1:size(Jason_lat)
    Jason_lon_s = Jason_lon(i);
    Jason_lat_s = Jason_lat(i);
    swh_s = Jason_swh(i);
    Jason_time_s = Jason_time(i);
    
    % 构建插入语句
    insertQuery = sprintf(['INSERT INTO public.Jason3_Point ' ...
        '(geom, swh, watchtime) VALUES (''POINT(%d %d)'', %d, ''%s'')'], ...
        Jason_lon_s,Jason_lat_s, swh_s, Jason_time_s);
    
    % 执行插入操作
    exec(conn, insertQuery);
end

% 关闭数据库连接
close(conn);








