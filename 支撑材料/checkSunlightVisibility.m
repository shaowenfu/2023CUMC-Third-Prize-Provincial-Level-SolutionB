%%
%判断A镜面上H1点处入射线向量是否被B或者塔阴影，出射线向量
% 是否被遮挡，t1、t2、t3分别表示入射和出射光线的遮挡情况，同时计算该入射线的余弦损失
function [t1,t2,t3,t4,Ncos] = checkSunlightVisibility(SINas, COSas, SINys, COSys, x0, y0, x1, y1,x_h,y_h)
    % 确定太阳入射线坐标
    x_sun = SINys * COSas;
    y_sun = COSys * COSas;
    z_sun = SINas;
    
    % 太阳入射线向量
    V_in_A = [x_sun; y_sun; z_sun];
    % 镜面出射线向量
    V_out_A = [-x0;-y0;76];

    % 初始点坐标
    OA = [x0; y0; 4];
    OB = [x1; y1; 4];

    % 调用函数求坐标转换矩阵T1和T2
    [T1,Ncos] = calculateCoordinateTransformationMatrix(SINas, COSas, SINys, COSys, x0, y0);
    [T2,~] = calculateCoordinateTransformationMatrix(SINas, COSas, SINys, COSys, x1, y1);

    % 对入射光线做坐标变换
    V_in_ground = V_in_A;
    V_in_B = T2' * V_in_ground;

    % 对出射光线做坐标变换
    V_out_ground = V_out_A;
    V_out_B = T2' * V_out_ground;

    % 任取A镜面上一点测试
    H1 = [x_h; y_h; 0];
    H1l = T1 * H1 + OA;
    H1ll = T2' * (H1l - OB);

    % 求入射线与B平面交点H2的坐标
    a1 = V_in_B(1);
    b1 = V_in_B(2);
    c1 = V_in_B(3);
    x_H = H1ll(1);
    y_H = H1ll(2);
    z_H = H1ll(3);
    x2 = (c1 * x_H - a1 * z_H) / c1;
    y2 = (c1 * y_H - b1 * z_H) / c1;

    % 判断结果
    if x2 >= -3 && x2 <= 3 && y2 >= -3 && y2 <= 3
        t1 = 0;
    else
        t1 = 1;
    end

    % 求出射线与B平面交点H2的坐标
    a2 = V_out_B(1);
    b2 = V_out_B(2);
    c2 = V_out_B(3);
    x_H = H1ll(1);
    y_H = H1ll(2);
    z_H = H1ll(3);
    x2 = (c2 * x_H - a2 * z_H) / c2;
    y2 = (c2 * y_H - b2 * z_H) / c2;
    % 判断结果
    if x2 >= -3 && x2 <= 3 && y2 >= -3 && y2 <= 3
        t2 = 0;
    else
        t2 = 1;
    end

    %建立塔的截面坐标系及相对地面的坐标转换方程
    tower_x=[0;0;1];
    tower_z=[V_in_ground(1);V_in_ground(2);0];
    tower_y=cross(tower_z,tower_x);
    T3=[tower_x,tower_y,tower_z];
    OC=[0;0;80];
    %判断入射线是否被塔遮挡
    H1 = [x_h; y_h; 0];
    H1l = T1 * H1 + OA;
    H1ll = T3' * (H1l - OC);
    V_in_s=T3'*V_in_ground;
    V_out_s=T3'*V_out_ground;
    % 求入射线与塔截平面交点H3的坐标
    a1 = V_in_s(1);
    b1 = V_in_s(2);
    c1 = V_in_s(3);
    x_H = H1ll(1);
    y_H = H1ll(2);
    z_H = H1ll(3);
    x2 = (c1 * x_H - a1 * z_H) / c1;
    y2 = (c1 * y_H - b1 * z_H) / c1;
    % 判断结果
    if x2 >= -80 && x2 <= 4 && y2 >= -3.5 && y2 <= 3.5
        t3 = 0;
    else
        t3 = 1;
    end
    % 求出射线与塔截平面交点H3的坐标
    a3 = V_out_s(1);
    b3 = V_out_s(2);
    c3 = V_out_s(3);
    x_H = H1ll(1);
    y_H = H1ll(2);
    z_H = H1ll(3);
    x3 = (c3 * x_H - a3 * z_H) / c3;
    y3 = (c3 * y_H - b3 * z_H) / c3;
    % 判断结果
    if x3 >= -4 && x3 <= 4 && y3 >= -3.5 && y3 <= 3.5
        t4 = 0;
    else
        t4 = 1;
    end
end
