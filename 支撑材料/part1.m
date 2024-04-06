%%
%画出散点图
clc;clear;close all;
data=readtable("附件.xlsx");
figure;
scatter(data,"x___m_","y___m_")
xlabel('定日镜横坐标'); % 替换 '横轴标签' 为您想要的标签
ylabel('定日镜纵坐标'); % 替换 '纵轴标签' 为您想要的标签
%%
clc; clear;

% 定义纬度
latitude = 39.4;
% 当地时间数据
ST = [9, 10.5, 12, 13.5, 15];
% 一年中的日期，每个日期表示一年中的第几天
D = [0, 31, 61, 92, 122, 153, 184, 214, 245, 275, 306, 337];

% 创建一个空表格
dataTable = table();

% 声明符号变量 x
syms x
for i = 1:length(D)
    for j = 1:length(ST)
        % 计算太阳时角
        W = (ST(j) - 12) * pi / 12;

        % 计算太阳赤纬角Q的正弦值和余弦值
        SINQ = solve(x - sin(2 * pi * D(i) / 365) * sin(46.9 * pi / 360), x);
        COSQ = sqrt(1 - SINQ^2);
        SINQ = double(SINQ);
        COSQ = double(COSQ);
        Q=asin(SINQ);

        % 计算太阳高度角 as
        SINas = solve(x - COSQ * cosd(latitude) * cos(W) - SINQ * sind(latitude));
        COSas = sqrt(1 - SINas^2);
        SINas = double(SINas);
        COSas = double(COSas);
        as=asin(SINas);

        % 计算太阳方位角 ys
        COSys = solve(x - (SINQ - SINas * sind(latitude)) / (COSas * cosd(latitude)));
        SINys = sqrt(1 - COSys^2);
        SINys = double(SINys);
        COSys = double(COSys);
        ys=asin(SINys);

        W=W*180/pi;
        Q=Q*180/pi;
        as=as*180/pi;
        ys=ys*180/pi;
        % 将计算结果存储在表格中
        dataRow = {W,Q,as,ys};
        dataTable = [dataTable; dataRow];
    end
end
% 显示表格
disp(dataTable);
writetable(dataTable,'太阳相关数据.xlsx');








