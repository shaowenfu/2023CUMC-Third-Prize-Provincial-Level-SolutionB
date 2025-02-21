%%
%计算某一时刻某面镜子的被遮挡比例以及平均余弦损失
function [percentage_1,percentage_2,Ncos] = calculateSunlightVisibilityPercentage(SINas, COSas, SINys, COSys, x0, y0, x1, y1)
    % 初始化随机数生成器
    rng('default');

    % 生成10000个随机数据对 (x_h, y_h)
    num_samples = 10000;
    x_h_range = [-3, 3];
    y_h_range = [-3, 3];
    x_h_values = (x_h_range(2) - x_h_range(1)) * rand(1, num_samples) + x_h_range(1);
    y_h_values = (y_h_range(2) - y_h_range(1)) * rand(1, num_samples) + y_h_range(1);

    % 初始化计数器
    count1 = 0;
    count2 = 0;
    % 循环计算 t 值
    total=0;
    for i = 1:num_samples
        x_h = x_h_values(i);
        y_h = y_h_values(i);

        [t1,t2,t3,t4,Ncos] = checkSunlightVisibility(SINas, COSas, SINys, COSys, x0, y0, x1, y1, x_h, y_h);
        total=total+Ncos;
        %入射线被B遮阴影、出射线被B遮挡、入射线被塔阴影
        % 根据返回值 t 进行处理
        if t1 == 1&&t2==1&&t3==1
            count1 = count1 + 1;
        end
        if t1 == 1&&t2==1&&t3==1&&t4==0
            count2 = count2 + 1;
        end
    end
    %计算平均余弦损失
    Ncos=total/num_samples;
    % 计算没被遮挡在所有点中的占比
    percentage_1 = count1 / num_samples * 100;
    % 计算截断率
    percentage_2= count2/count1*100;
end
