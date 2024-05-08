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

SWAN = load("WAVE2022.mat");
field_names = fieldnames(SWAN);

% 存储属性字段名称
list = cell(numel(field_names), 1);

for i = 1:numel(field_names)
    list{i} = field_names{i};
end

Hsig_list = list(1:2:end);
Dir_list = list(2:2:end);

% 初始化8760x27349的数据矩阵
SWAN_data = zeros(8760, 10613);

for i = 1:8760
    field_name = sprintf(Hsig_list{i});
    SWAN_data(i, :) = SWAN.(field_name);
end

%% 3.读取观测数据

observation_data = importdata('./中国台站观测数据2022/BSG2201.txt');
ob_data = observation_data.data;
ob = ob_data(:,2);
ob(ob > 50) = NaN;

%% 4.清理工作区

clear i field_name SWAN num_fields list field_names txtData address_data addresstxtData  observation_data

%% 5.绘制等值线图


addpath('../m_map');  % m_map工具箱的文件夹路径

% 选择输入日期序号
comdate = 300;

% 离散点的x、y和z数据
x = lon;
y = lat;
z = SWAN_data(comdate,:); % 单个时间点数据
%z = mean(SWAN_data) + 0.45; % 全年数据均值

time = 1:744;
s = SWAN_data(:,9358);
s = s(1:744);
figure;
subplot(211);
scatter(time, ob, 'filled', 'MarkerFaceColor', 'red');
hold on;
plot(time, s, 'b-', 'LineWidth', 2);
legend('观测数据', 'SWAN模拟数据');
% 设置长宽比
aspect_ratio = 3;  % 设置长宽比为0.5

% 获取图像对象
h = gcf;

% 获取图像的当前位置
position = h.Position;

% 计算新的宽度
new_width = position(4) * aspect_ratio;

% 更新图像的位置
h.Position(3) = new_width;
% 添加标题和轴标签
title('北霜站验证数据（2022年1月）');
% xlabel('X轴');
% ylabel('Y轴');

% 显示网格
grid on;


% 定义网格的x和y范围
x_range = linspace(min(x), max(x), 2000);
y_range = linspace(min(y), max(y), 2000);

% 创建网格坐标
[X, Y] = meshgrid(x_range, y_range);

% 使用griddata进行插值
Z = griddata(x, y, z, X, Y, 'cubic');

m_proj('mercator', 'long',[116.5 122],'lat',[21.75 27.5]); 
subplot(212);
% 绘制等高线图
m_contourf(X, Y, Z)
hold on;
m_grid('tickdir','out','yaxislocation','right',...
            'xaxislocation','top','xlabeldir','end','ticklen',.02);

m_gshhs_h('patch',[.9 .9 .9]);

m_line(120.3, 26.7,'marker','square','markersize',5,'color','r','linewidth',2);
m_text(120.3, 26.7,'北霜站','vertical','top','color','r','linewidth',2);
m_line(117.5, 23.8,'marker','square','markersize',5,'color','r','linewidth',2);
m_text(117.5, 23.8,'东山站','vertical','top','color','r','linewidth',2);
m_line(118.1, 24.5,'marker','square','markersize',5,'color','r','linewidth',2);
m_text(118.1, 24.5,'厦门站','vertical','top','color','r','linewidth',2);

m_ruler([.1 .6],.08,3,'fontsize',10);

m_northarrow(117.2,27,.7,'type',3);

ax=m_contfbar(.07,[.5 .9],[0 4],[0:0.1:4],'edgecolor','none','endpiece','no');
xlabel(ax,'meters','color','k');

% 添加标题和轴标签
%title('二维等高线图');
%xlabel('x坐标');
%ylabel('y坐标');

%% 6.清理工作区

clear x y SWAN 
