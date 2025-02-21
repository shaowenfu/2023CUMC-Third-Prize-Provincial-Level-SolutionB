function [T,Ncos] = calculateCoordinateTransformationMatrix(SINas, COSas, SINys, COSys, x0, y0)
    % 确定太阳入射线坐标
    x_sun = SINys * COSas;
    y_sun = COSys * COSas;
    z_sun = SINas;

    % 确定镜面中心点坐标和出射线向量单位向量
    V_out = [-x0; -y0; 76];
    magnitude = norm(V_out); % 计算向量的模长
    unit_vector = V_out / magnitude; % 单位化向量
    V_out = unit_vector;

    % 太阳入射线向量
    V_in = [x_sun; y_sun; z_sun];

    % 求镜面法向量
    V_m = V_in + V_out;
    magnitude = norm(V_m); % 计算向量的模长
    unit_vector = V_m / magnitude; % 单位化向量
    V_m = unit_vector;

    %求余弦损失
    Ncos=dot(V_m,V_in);

    % 求镜面坐标系x轴方向向量
    % 令x为1，z为0
    b = -V_m(1) / V_m(2);
    V_x = [1; b; 0];

    % 求镜面坐标系y轴方向向量
    V_y = cross(V_m, V_x);

    % 求坐标转换矩阵T
    T = [V_x, V_y, V_m];
end
