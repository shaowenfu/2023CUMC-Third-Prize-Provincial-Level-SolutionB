%%月平均阴影效率
function resultTable = calculateSunlightVisibilityForYear(x0, y0, x1, y1, data)
    % 初始化表格
    resultTable = table();
    % 循环处理数据
    for i = 1:size(data, 1)
        SINas = table2array(data(i, 1));
        COSas = table2array(data(i, 2));
        SINys = table2array(data(i, 3));
        COSys = table2array(data(i, 4));

        % 调用函数并获取输出
        [percentage1,percentage2,Ncos] = calculateSunlightVisibilityPercentage(SINas, COSas, SINys, COSys, x0, y0, x1, y1);

        % 将结果存储在表格中，每5个数据放在一行
        if mod(i, 5) == 1
            newRow = table();
        end
        newRow.('余弦损失')=Ncos;
        newRow.(['阴影效率', num2str(mod(i, 5))]) = percentage1;
        newRow.(['截断效率', num2str(mod(i, 5))]) = percentage2;

        if mod(i, 5) == 0
            resultTable = [resultTable; newRow];
        end
    end
    NewCol1=ones(12,1);
    NewCol2=ones(12,1);
    for i=1:12
        res1=table2array(resultTable(i,2))+table2array(resultTable(i,4))+table2array(resultTable(i,6))+table2array(resultTable(i,8))+table2array(resultTable(i,10));
        avg1=res1/5;
        NewCol1(i,1)=avg1;
        res2=table2array(resultTable(i,3))+table2array(resultTable(i,5))+table2array(resultTable(i,7))+table2array(resultTable(i,9))+table2array(resultTable(i,11));
        avg2=res2/5;
        NewCol1(i,1)=avg2;
    end
    resultTable = [resultTable, table(NewCol1, 'VariableNames', {'平均阴影效率'})];
    resultTable = [resultTable, table(NewCol1, 'VariableNames', {'平均截断效率'})];
end
