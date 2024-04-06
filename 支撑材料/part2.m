%%
% 计算第i面镜子的光学效率Ni
clc;clear;
%%
% 计算光学效率
% 计算阴影遮挡效率和余弦效率
datas = readtable("太阳高度角与方位角.xlsx");
location=readtable("附件.xlsx");
data = datas(:, 3:6);
SINas = table2array(data(:, 1));
COSas = table2array(data(:, 2));
SINys = table2array(data(:, 3));
COSys = table2array(data(:, 4));
X0=[-59.987,-9.07,242.266,120.012,3.775,-9.07,-214.862,-147.257];
Y0=[249.099,121.028,15.091,18.089,-242.706,-121.028,19.715,17.88];
X1=[-56.115,-5.841,229.134,107.25,3.637,-5.841,-201.381,-133.597];
Y1=[236.16,107.724,7.274,11.664,-229.24,-107.724,19.036,18.362];
i=1;
x0 =X0(i);
y0 =Y0(i);
x1 =X1(i);
y1 =Y1(i);
% 调用函数并获取输出
resultTable = calculateSunlightVisibilityForYear(x0, y0, x1, y1, data);
%这里直接用均值代替了
Nsb=table2array(resultTable(:,12));
Nsb=Nsb./100;
Ncos=table2array(resultTable(:,2));
%计算大气透射率
dHR=0;
[Rownum,Colnum]=size(location);
for i=1:Rownum
    a=table2array(location(i,1));
    b=table2array(location(i,2));
    dHR=dHR+sqrt(a*a+b*b+76*76);
end
dHR=dHR/Rownum;
%  dHR=dHR+sqrt(x0*x0+y0*y0+76*76);
Nat=0.99321-1.176e-4*dHR+1.97e-8*dHR*dHR;
%计算截断效率
Ntrunc=table2array(resultTable(:,13));
%计算镜面反射率
Nref=0.92;
%计算光学效率
Nlight=Nsb.*Ncos.*Nat.*Ntrunc.*Nref
%%
%%
% 计算输出热功率
% 计算法向直接辐射辐照度DNI
H=3;
a=0.4237-0.00821*(6-H)*(6-H);
b=0.5055+0.00595*(6.5-H)*(6.5-H);
c=0.2711+0.01858*(2.5-H)*(2.5-H);
G0=1.366;
temp=c./SINas;
DNI=G0*(a+b*exp(-temp));
avg_DNI=zeros(12,1);
flag=0;
res=0;
for i=1:60
    if (mod(i,5)==1&&i>5)||(i==60)
        flag=flag+1;
        res=res/5;
        avg_DNI(flag)=res;      
        res=DNI(i);
    else
        res=res+DNI(i);
    end
end

%计算定日镜场输出热功率Efiled
A=Nsb;
Efield=0;
N=1745;
Efield=avg_DNI.*A*N;
avg_Efield=Efield/(N*36);
Efield=Efield/1024