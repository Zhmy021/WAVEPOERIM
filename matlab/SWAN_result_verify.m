clc; clear; close all;

%% 1. 读取网格坐标数据

% 读取位置数据
address_data = importdata('fort2022.txt');
addresstxtData = address_data.data; 
txtData = addresstxtData(2:10614, :);

% 读取经纬度坐标
lon = txtData(:, 2);
lat = txtData(:, 3);
depth = txtData(:, 4);

%% 2. 读取SWAN计算数据

result_WST_S1 = READ_MAT("./0322/te_WSTS1.mat",9358,1);
result_WST_S2 = READ_MAT("./0322/te_WSTS2.mat",9358,1);
result_modKom1 = READ_MAT("./0322/te_modKomS1.mat",9358,1);
result_modKom2 = READ_MAT("./0322/te_modKomS2.mat",9358,1);
result_Kom = READ_MAT("./0322/te_Kom.mat",9358,1);
result_ST6_S1 = READ_MAT("./0322/te_ST6_S1.mat",9358,1);
result_ST6_S2 = READ_MAT("./0322/te_ST6_S2.mat",9358,1);
result_ST6_S3 = READ_MAT("./0322/te_ST6_S3.mat",9358,1);
result_ST6_S4 = READ_MAT("./0322/te_ST6_S4.mat",9358,1);

%% 3. 读取观测数据

observation_data1 = importdata('./中国台站观测数据2022/BSG2201.txt');
observation_data2 = importdata('./中国台站观测数据2022/BSG2202.txt');

ob_data1 = observation_data1.data;
ob_data2 = observation_data2.data;

ob1 = ob_data1(:,2)-0.09;
ob1(ob1 > 50 | ob1 < 0.2) = NaN;

ob2 = ob_data2(:,2)-0.09;
ob2(ob2 > 50 | ob2 < 0.2) = NaN;

ob = [ob1;ob2];

ob = ob(34:753);

%% 4. 绘制等值线图

time = 25:744;
scatter(time, ob, 'filled', 'MarkerFaceColor', 'red');
hold on;
plot(time, result_WST_S1(25:744), 'b', 'LineWidth', 2);
plot(time, result_WST_S2(25:744), 'g', 'LineWidth', 2);
plot(time, result_modKom1(25:744), 'm', 'LineWidth', 2);
plot(time, result_modKom2(25:744), 'c', 'LineWidth', 2);
plot(time, result_Kom(25:744), 'm', 'LineWidth', 2);
plot(time, result_ST6_S1(25:744), 'c', 'LineWidth', 2);

legend('观测数据', 'WST_S1','WST_S2','result_modKom1','result_modKom2','result_Kom','result_ST6_S1');

%% 5. 计算偏差
list11 = ob;
list22 = [result_WST_S1(25:744),result_WST_S2(25:744),result_modKom1(25:744),result_modKom2(25:744),result_Kom(25:744),result_ST6_S1(25:744)];
lego = {'WST_S1','WST_S2','result_modKom1','result_modKom2','result_Kom','result_ST6_S1'};
for i=1:1:6
    listcom = list22(:,i);
    validIndices = ~isnan(list11) & ~isnan(listcom);  % 获取有效的索引
    
    list1 = list11(validIndices);
    list2 = listcom(validIndices');
    
    diff = list1 - list2;
    
    bias = mean(diff);
    
    rmsd = sqrt(mean(diff.^2));
    
    correlation = corrcoef(list1, list2);
    
    corr_value = correlation(1, 2);
    
    disp([char(lego(i)),'偏差为：', num2str(bias)]);
    disp([char(lego(i)),'RMSD为：', num2str(rmsd)]);
    disp([char(lego(i)),'相关性为：', num2str(corr_value)]);
end

