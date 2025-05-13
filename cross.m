%% SRF_cross_fx为背景，文件路径修改一个位置即可，平均使用封装函数
clear;clc;close all;warning off
%% 平均最后n个光谱数据文件
dir1 = 'F:\课题\数据\武\S\7.8\高温bd\';
dir2 = 'F:\课题\数据\武\S\7.8\0\';
dir3 = 'F:\课题\数据\武\S\8.6\高温bd\';
dir4 = 'F:\课题\数据\武\S\8.6\2\';
file_list1 = dir(fullfile(dir1, '*.txt'));
file_list2 = dir(fullfile(dir2, '*.txt'));
file_list3 = dir(fullfile(dir3, '*.txt'));
file_list4 = dir(fullfile(dir4, '*.txt'));

u0=245;v0=320;%测量波段
u1=u0-1;v1=v0+1;%拟合波段
%标注浓度，测量浓度
S_S2=1;M_C=500;S_C_CS2=180;
len1 = size(file_list1, 1);
len2 = size(file_list2, 1);
len3 = size(file_list3, 1);
len4 = size(file_list4, 1);

Q1=[];Q2=[];Q3=[];Q4=[];
%% 标准谱采用最后10个文件
[n, MN] = deal(10, floor(length(file_list1) / 10));
Q1 = averageSpectralData(dir1, file_list1, n);
Q2 = averageSpectralData(dir2, file_list2, n);
beidishuju1 = Q1;
celiangshuju1 = Q2;
[beidibochang1, beidiguangqiang1] = deal(beidishuju1(:,1), beidishuju1(:,2));
[celiangbochang1, celiangguangqiang1] = deal(celiangshuju1(:,1), celiangshuju1(:,2));
%% 测量波长与拟合波长选取
array=beidishuju1(:,1);
u00 = findClosestNum(array, u0);
v00 = findClosestNum(array, v0);
u11 = findClosestNum(array, u1);
v11 = findClosestNum(array, v1);
wave1=[u00,v00];
wave2=[u11,v11];
% fprintf('吸收波长: ');
% fprintf('%f ', wave1);
% fprintf('\n');
% fprintf('拟合波长: ');
% fprintf('%f ', wave2);
% fprintf('\n');  % 可选，添加换行符
%% 差分谱1
% [yongdebochang1, chafenpu1] = processDifferenceSpectrum(celiangshuju1, beidishuju1, u00, v00, u11, v11, 4);
xishoupu1=celiangguangqiang1./beidiguangqiang1;
u01 = find(celiangbochang1==u00);
v01 = find(celiangbochang1==v00);
yongdexishoupu1=xishoupu1(u01:v01,1);
yongdebochang1=celiangbochang1(u01:v01,1);%用的吸收谱波长选取

u12 = find(celiangbochang1==u11);
v12 = find(celiangbochang1==v11);
nihebochang1=celiangbochang1(u12:v12,1);
nihexishoupu1=xishoupu1(u12:v12,1);
manbianxishou=polyfit(nihebochang1,nihexishoupu1,4);
manbianxishou1=polyval(manbianxishou,nihebochang1);
manbianpu1=[nihebochang1,manbianxishou1];
u22 = find(nihebochang1==u00);
v22 = find(nihebochang1==v00);
yongdemanbian1=manbianpu1(u22:v22,:);%用的慢变拟合波段选取

kuaibianxishoupu2=yongdexishoupu1./yongdemanbian1(:,2);
chafenpu1=log(kuaibianxishoupu2);%取对数
%% 标准谱2的bd采用最后10个文件
Q3 = averageSpectralData(dir3, file_list3, n);
beidishuju2 = Q3;
[beidibochang2, beidiguangqiang2] = deal(beidishuju2(:,1), beidishuju2(:,2));
%% 谱2的透过谱采用最后10个
for i7=1:1:5
% Ta=5;
% tt=5;
% for i7=len4-(Ta*tt+1):len4-Ta*tt
    fileName4 = file_list4(i7).name;  % 获取文件名
    filePath4 = fullfile(dir4, fileName4);  % 拼接完整路径
    fileID4 = fopen(filePath4);  % 打开文件
    A4=textscan(fileID4,'%f%f');
    %     figure
    %     plot(A3{1,1},A3{1,2});
    %     hold on;
    Q4=[Q4;A4];
    fclose all;
end
celiangbochang2=Q4{1,1};
a4=zeros(length(celiangbochang2),1);
for i8=1:length(Q4)
    a4=a4+Q4{i8,2};
end
%平均了最后10个文件的测量谱2数据
celiangguangqiang2=a4/length(Q4);
celiangshuju2=[celiangbochang2 celiangguangqiang2];
%% 差分谱2
% [yongdebochang02, chafenpu02] = processDifferenceSpectrum(celiangshuju2, beidishuju2, u00, v00, u11, v11, 4);
xishoupu02=celiangguangqiang2./beidiguangqiang2;
yongdexishoupu02=xishoupu02(u01:v01,1);
yongdebochang02=celiangbochang1(u01:v01,1);%用的吸收谱波长选取
nihebochang1=celiangbochang1(u12:v12,1);
nihexishoupu02=xishoupu02(u12:v12,1);
manbianxishou02=polyfit(nihebochang1,nihexishoupu02,4);
manbianxishou02=polyval(manbianxishou02,nihebochang1);
manbianpu02=[nihebochang1,manbianxishou02];%用的慢变拟合波段选取
yongdemanbian02=manbianpu02(u22:v22,:);
kuaibianxishoupu02=yongdexishoupu02./yongdemanbian02(:,2);
chafenpu02=log(kuaibianxishoupu02);%取对数
%% 差分谱2选择另一个波段
u_2th=250;v_2th=275;
u00_2th = findClosestNum(array, u_2th);
v00_2th = findClosestNum(array, v_2th);
wave3=[u00_2th,v00_2th];
%% 差分谱2的部分
yongdebochang2=celiangbochang2(find(celiangbochang2==u00_2th):find(celiangbochang2==v00_2th),1);
u01_2th = find(yongdebochang02==u00_2th);
v01_2th = find(yongdebochang02==v00_2th);
chafenpu2=chafenpu02(u01_2th:v01_2th);
%% 图1两个差分谱
y1=chafenpu1;
y2=chafenpu2;
plot(yongdebochang1,chafenpu1,'r')
hold on
plot(yongdebochang2,chafenpu2,'o')
hold on
plot(yongdebochang1,chafenpu02,'b')
title('两组差分谱');
xlabel('波长λ(nm)');
ylabel('差分吸收光谱(a.u)');
legend('标准浓度S2差分谱','选取波段','待测差分谱')
%% 多余数值赋NAN
zuo=find(yongdebochang1==yongdebochang2(1));
zuo_2=zuo-1;
you=find(yongdebochang1==yongdebochang2(length(yongdebochang2)));
you_2=length(yongdebochang1)-you;
row_1=NaN(1, zuo_2);
row_2=NaN(1, you_2);
y2_2=[row_1 y2' row_2]';
%% 排序
bochang=yongdebochang1;
m=length(bochang);
a=1:m;
Y=[y1 y2_2 a'];
Y0=[y1 y2_2];
Y1=sortrows(Y,1);%标准谱从小到大排序，测量谱跟着变动
Y01=sortrows(Y0,1);
%% 图3 标准谱线性
X=[];
X(1)=0;
for p1=2:length(Y1)
    X(p1)=1*(Y1(p1,1)-Y1(p1-1,1))+X(p1-1);
    p1=p1+1;
end
XX=X';
lunwen02=[X' Y01];
figure
plot(X,Y01);
legend('标准排序','待测排序')
%% 图 线性标准谱，拟合测量谱
cc=Y1(:,2)';

non_nan_rows = any(isnan(lunwen02), 2);
Y01_cleaned = lunwen02(~non_nan_rows, :);

yn=polyfit(Y01_cleaned(:,1),Y01_cleaned(:,3),1);
ynn=polyval(yn,Y01_cleaned(:,1));
% Y2=[Y1(:,1) y2_4'];
% Y3=[Y1(:,1) ynn'];
figure
plot(Y01_cleaned(:,1),ynn,'b');
legend('拟合')
Con_S2=yn(1)*S_S2
Y_augment=yn(1)*X+yn(2);
Y_augment=Y_augment';
figure
plot(X,Y_augment,'b');
legend('扩展')
%% 图6 逆重构
Y31=[Y1(:,1) Y_augment Y1(:,3)];
Y32=sortrows(Y31,3);
Y33=[Y32(:,1) Y32(:,2)];
bochang=bochang';
figure
plot(yongdebochang2,chafenpu2,'o');hold on
plot(bochang,Y33(:,2),'r');hold on
plot(yongdebochang1,chafenpu02,'b')
title('三组差分谱');
xlabel('波长λ(nm)');
ylabel('差分吸收光谱(a.u)');
legend('选取波段','逆重构差分谱','原始光谱')
a_1=1:length(cc);
% U=[a_1' Y1(:,1) ynn'];
%% 减去S2特征
Y_CS2=chafenpu02-Y32(:,2);
figure
plot(yongdebochang1,Y_CS2,'r');hold on
plot(yongdebochang1,chafenpu02,'b')
legend('减去S2特征后','原始光谱')
A_getCS2=[yongdebochang1 Y_CS2];
figure
plot(yongdebochang1,Y32(:,2),'r');hold on
plot(yongdebochang1,chafenpu1,'b')
legend('光谱重构恢复的光谱','标准S2')
%% 除去SO2吸收后差分谱反演回吸收谱
A_SRF=Y33(:,2);%除去SO2吸收后差分谱
A_fast=exp(A_SRF);
A_slow=yongdemanbian02(:,2);
A_all=A_fast.*A_slow;
%% 吸收截面计算
C=450*10^(-6);%浓度
L=0.3;
N_A=6.02*10^(23);
V_m=24.5*10^(-3);%22.4
cross_S2_1=-log((yongdexishoupu02))*V_m./(C*N_A*L)*10^4;%没有归一化的吸收截面
cross_S2_2=-log((A_all))*V_m./(C*N_A*L)*10^4;%没有归一化的吸收截面
A_CROSS=sum(cross_S2_2)*10^17
cross_S2=[cross_S2_1 cross_S2_2];
%% 吸收截面对比图
% figure
% plot(yongdebochang02,yongdexishoupu02)
% title('吸收谱');
% xlabel('波长λ(nm)');
% ylabel('测量/bd(a.u)');
figure
plot(yongdebochang02,cross_S2_1,'r');hold on
plot(yongdebochang02,cross_S2_2,'b')
title('吸收截面');
xlabel('波长λ(nm)');
ylabel('吸收截面(a.u)');
legend('原始光谱','减去SO2特征后')