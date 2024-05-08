clc; clear; close all;

%% 1.读取网格坐标数据

% 读取位置数据
address_data = importdata('fort2022.txt');
addresstxtData = address_data.data; 
txtData = addresstxtData(2:10614, :);

% 读取经纬度坐标
lon = txtData(:, 2);
lat = txtData(:, 3);
depth = txtData(:, 4);

%% 2.读取SWAN计算数据

SWAN = load("./0322/te_ST6_S4.mat");
field_names = fieldnames(SWAN);

% 存储属性字段名称
list = cell(numel(field_names), 1);

for i = 1:numel(field_names)
    list{i} = field_names{i};
end

Hsig_list = list(1:4:end);
Dir_list = list(2:4:end);
Tm01_list = list(3:4:end);
Tm02_list = list(4:4:end);

% 初始化8760x27349的数据矩阵
Hsig_data = zeros(744, 10613);
Tm02_data = zeros(744, 10613);

for i = 1:744
    Hsig_name = sprintf(Hsig_list{i});
    Tm02_name = sprintf(Tm02_list{i});
    Hsig_data(i, :) = SWAN.(Hsig_name);
    Tm02_data(i, :) = SWAN.(Tm02_name);
end
SWAN_data = 0.5 * (Hsig_data .* Hsig_data .* Tm02_data);


%% 3.读取观测数据

observation_data = importdata('./中国台站观测数据2022/BSG2201.txt');
ob_data = observation_data.data;

%% 4.清理工作区

clear i num_fields list field_names txtData address_data addresstxtData  observation_data

%% 5.绘制等值线图

addpath('../m_map');  % m_map工具箱的文件夹路径

% 选择输入日期序号
comdate = 50;
frequency = sum(SWAN_data > 20) / size(SWAN_data, 1);
mean_values = mean(SWAN_data(2:end,:));


% 离散点的x、y和z数据
x = lon;
y = lat;
z = mean_values; % 单个时间点数据
% z = mean(SWAN_data); % 全年数据均值

% 定义网格的x和y范围
x_range = linspace(min(x), max(x), 2000);
y_range = linspace(min(y), max(y), 2000);

% 创建网格坐标
[X, Y] = meshgrid(x_range, y_range);

% 使用griddata进行插值
Z = griddata(x, y, z, X, Y, 'natural');

% 绘制等高线图
m_contourf(X, Y, Z);

hold on;

m_grid('tickdir','out','yaxislocation','right',...
            'xaxislocation','top','xlabeldir','end','ticklen',.02);

m_gshhs_h('patch',[0.6 0.6 0.6]);

m_ruler([.1 .6],.08,3,'fontsize',10);

m_northarrow(117.2,27,.7,'type',3);

ax=m_contfbar(0.07,[0.5 0.9],[0 1], [0:0.05:1],'edgecolor','none','endpiece','no');

xlabel(ax,'','color','k');




latlim = [21.75 27.5];
lonlim = [116.5 122.25];
rasterSize = [2000 2000];
R = georefcells(latlim,lonlim,rasterSize);
geotiffwrite('C_wavepower_mean.tif', Z, R);


% 添加标题和轴标签
%title('二维等高线图');
%xlabel('x坐标');
%ylabel('y坐标');

%% 6.清理工作区

clear x y 
