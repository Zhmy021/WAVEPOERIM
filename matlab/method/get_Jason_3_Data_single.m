function combined_matrix = get_Jason_3_Data_single(filename)


swh = ncread(filename, 'swh');
lat = ncread(filename, 'lat');
lon = ncread(filename, 'lon');
time = ncread(filename, 'time');
windsp = ncread(filename, 'wind_speed_alt');

% 假设你要筛选的地理范围为（min_lat, max_lat）和（min_lon, max_lon）
min_lat = 21.75;
max_lat = 27.5;
min_lon = 116.4;
max_lon = 122;

% 合并条件并筛选数据
idx = find(lat >= min_lat & lat <= max_lat & lon >= min_lon & lon <= max_lon);

% 筛选符合地理范围的数据
filtered_swh = swh(idx);
filtered_lat = lat(idx);
filtered_lon = lon(idx);
filtered_time = time(idx);
filtered_windsp = windsp(idx);

datetime_str = strings(size(filtered_time));

% 循环遍历每个时间戳，并将其转换为日期时间字符串
for i = 1:numel(filtered_time)
    datetime_str(i) = datetime(filtered_time(i)/86400 + datetime(1985,1,1));
end

% 合并筛选后的数据
combined_matrix = horzcat(filtered_lat, filtered_lon, filtered_swh, filtered_windsp, datetime_str);