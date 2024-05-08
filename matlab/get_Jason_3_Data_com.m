function combined_matrix = get_Jason_3_Data_com(folder_path)

combined_matrix = [];
% 获取文件夹内的文件列表
file_list = dir(folder_path);

% 循环读取文件
for i = 1:length(file_list)
    % 忽略文件夹和上级目录
    if file_list(i).isdir || strcmp(file_list(i).name, '.') || strcmp(file_list(i).name, '..')
        continue;
    end
    
    file_path = fullfile(folder_path, file_list(i).name);
    sigle = get_Jason_3_Data_single(file_path);
    combined_matrix = [combined_matrix; sigle];
end
