clear, clc

folder_path = 'JASON3333';

file_list = dir(folder_path);


% 循环读取文件
for J = 1:length(file_list)
    % 忽略文件夹和上级目录
    if file_list(J).isdir || strcmp(file_list(J).name, '.') || strcmp(file_list(J).name, '..')
        continue;
    end

    disp(file_list(J).name)
    file_path = fullfile(folder_path, file_list(J).name);

    filename = file_path;
    

    time = ncread(filename, 'TIME');
    lat = ncread(filename, 'LATITUDE');
    lon = ncread(filename, 'LONGITUDE');
    swh = ncread(filename,'SWH_C');
    
    datetime_str = strings(size(time));
    
    % 循环遍历每个时间戳，并将其转换为日期时间字符串
    for i = 1:numel(time)
        datetime_str(i) = datetime(time(i) + datetime(1985,1,1));
    end
    
    conn = database('postgres','postgres','742111', 'org.postgresql.Driver','jdbc:postgresql://localhost:5432/postgres');
    
    % 检查连接状态
    if isopen(conn)
        disp('数据库连接成功！');
    else
        disp('数据库连接失败！');
    end
    
    for i = 1:size(lat)
        Jason_lon_s = lon(i);
        Jason_lat_s = lat(i);
        swh_s = swh(i);
        Jason_time_s = datetime_str(i);
        
        % 构建插入语句
        insertQuery = sprintf(['INSERT INTO public.Jason3_Point ' ...
            '(geom, swh, watchtime) VALUES (''POINT(%d %d)'', %d, ''%s'')'], ...
            Jason_lon_s,Jason_lat_s, swh_s, Jason_time_s);
        
        % 执行插入操作
        exec(conn, insertQuery);
    end
    
    % 关闭数据库连接
    close(conn);

end
