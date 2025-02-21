%%
%求某面镜子A在全年60个时间点被它前面镜子B遮挡的比例
% 已知的60组数据
clc;clear;
datas = readtable("太阳高度角与方位角.xlsx");
data = datas(:, 3:6);
data1=readtable('附件.xlsx');
[N,Colnum]=size(data1);
Ncos=zeros(12,1);
% for i=1:N
%     for j=1:N
%         if j~=i
%         x0 = table2array(data1(i,1));
%         y0 = table2array(data1(i,2));
%         x1= table2array(data1(j,1));
%         y1 = table2array(data1(j,2));
%         resultTable = calculateSunlightVisibilityForYear(x0, y0, x1, y1, data);
%         avg_sb=resultTable.("平均阴影效率");
%         avg_tranc=resultTable.("平均截断效率");
%         Ncos=Ncos+resultTable.("余弦损失");
%         end
%     end
% end
% avg_sb=avg_sb/(N*N);
% avg_tranc=avg_tranc/(N*N);
% Ncos=Ncos/(N*N);
X0=[-59.987,-9.07,242.266,120.012,3.775,-9.07,-214.862,-147.257];
Y0=[249.099,121.028,15.091,18.089,-242.706,-121.028,19.715,17.88];
X1=[-56.115,-5.841,229.134,107.25,3.637,-5.841,-201.381,-133.597];
Y1=[236.16,107.724,7.274,11.664,-229.24,-107.724,19.036,18.362];
final_result_sb = table();
final_result_tranc = table();
final_result_cos = table();

for i = 1:8
    x0 = X0(i);
    y0 = Y0(i);
    x1 = X1(i);
    y1 = Y1(i);
    
    % 调用函数并获取输出
    resultTable = calculateSunlightVisibilityForYear(x0, y0, x1, y1, data);
    avg_sb = resultTable.("平均阴影效率");
    avg_tranc = resultTable.("平均截断效率");
    Ncos = resultTable.("余弦损失");
    
    % 将结果添加为表格
    temp_sb = table(avg_sb, 'VariableNames', {['平均阴影效率_', num2str(i)]});
    temp_tranc = table(avg_tranc, 'VariableNames', {['平均截断效率_', num2str(i)]});
    temp_cos = table(Ncos, 'VariableNames', {['余弦损失_', num2str(i)]});
    
    final_result_sb = [final_result_sb, temp_sb];
    final_result_tranc = [final_result_tranc, temp_tranc];
    final_result_cos = [final_result_cos, temp_cos];
end

% 打印表格
disp(final_result_sb);
disp(final_result_tranc);
disp(final_result_cos);
 writetable(final_result_sb,'最终结果--阴影效率.xlsx');
  writetable(final_result_cos,'最终结果--余弦效率.xlsx');
   writetable(final_result_tranc,'最终结果--截断效率.xlsx');

% 假设 final_result_sb 是您的表格
avg_sb_per_row = mean(final_result_sb{:, 1:end}, 2); % 从第二列开始计算平均值，按行
avg_tranc_per_row = mean(final_result_tranc{:, 1:end}, 2);
avg_cos_per_row = mean(final_result_cos{:, 1:end}, 2);

% 创建包含平均值的新表格
avg_table = table(avg_sb_per_row, avg_tranc_per_row, avg_cos_per_row, 'VariableNames', {'平均阴影效率', '平均截断效率', '平均余弦损失'});

% 打印新表格
disp(avg_table);
 writetable(avg_table,'最终结果平均值.xlsx');










