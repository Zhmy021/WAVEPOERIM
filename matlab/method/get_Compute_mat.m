function result = get_Compute_mat(filename, KIND)
% KIND中1为swh，2为dir，3为tm01,4为tm02

SWAN = load(filename);
field_names = fieldnames(SWAN);

% 存储属性字段名称
list = cell(numel(field_names), 1);

for i = 1:numel(field_names)
    list{i} = field_names{i};
end

list = list(KIND:4:end);

% 初始化8760x27349的数据矩阵
SWAN_data = zeros(744, 10613);
    
for i = 1:744
    field_name = sprintf(list{i});
    SWAN_data(i, :) = SWAN.(field_name);
end

result = SWAN_data;