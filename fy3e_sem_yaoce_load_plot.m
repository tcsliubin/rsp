clear;clc;
filepath = 'D:\MyWork\01 ResearchWork\01 型号\fy3e\data\遥测数据\Result\';
filename = '结果文件2021-08-18-20-38-11.dat';
data_table = readtable([filepath, filename]);
data_cell = table2cell(data_table);

time = datenum(data_cell(:,1),'yyyy年mm月dd日HH时MM分SS秒');
gps_x = str2double(data_cell(:,4));   gps_y = str2double(data_cell(:,5));   gps_z = str2double(data_cell(:,6));

dc2 = data_cell(:,15);   dc1 = data_cell(:,16);  % 差异电位2、1的源码

highv3 = str2double(data_cell(:,17));  % 电子主高压
highv4 = str2double(data_cell(:,18));  % 电子MCP高压
highv1 = str2double(data_cell(:,19));  % 离子主高压
highv2 = str2double(data_cell(:,20));  % 离子MCP高压

erciv3 = str2double(data_cell(:,21));  % 二次电源检测3
erciv2 = str2double(data_cell(:,22));  % 二次电源检测2
erciv1 = str2double(data_cell(:,23));  % 二次电源检测1

ele_esa = str2double(data_cell(:,34));  % 电子ESA高压
ele_i = str2double(data_cell(:,35));    % 电子高压电流
v_12v = str2double(data_cell(:,36));    % 绝对电位高压+12V
ion_esa = str2double(data_cell(:,37));  % 离子ESA高压
ion_i = str2double(data_cell(:,38));    % 离子高压电流

data.time = time;
data.gps_x = gps_x; data.gps_y = gps_y; data.gps_z = gps_z;
data.dc1 = dc1; data.dc2 = dc2;
data.highv1 = highv1; data.highv2 = highv2; data.highv3 = highv3; data.highv4 = highv4;
data.erciv1 = erciv1; data.erciv2 = erciv2; data.erciv3 = erciv3;
data.ion_esa = ion_esa; data.ele_esa = ele_esa; data.v_12v = v_12v;
data.ion_i = ion_i; data.ele_i = ele_i;

% save fy3e_yaoce_20210814080002_20210818163406 data

%% plot
clear;clc;
load('fy3e_yaoce_20210804080003_20210814075956.mat')
%% 1 电子、离子ESA高压、电流
index = find(~isnan(data.ion_esa));
t1 = floor(data.time(index(1)));   t2 = ceil(data.time(index(end)));

scrsz = get(groot,'ScreenSize');
figure('Position',scrsz)

subplot(2,1,1)
plot(data.time(index),[data.ion_esa(index),data.v_12v(index),data.ele_esa(index)],'linewidth',2)
set(gca,'xlim',[t1 t2]);
set(gca,'xtick',t1:t2); set(gca,'xticklabel',[]);
ylabel('电压','fontsize',12);
grid on
legend('电子ESA高压','绝对电位高压+12V','离子ESA高压')

subplot(2,1,2)
plot(data.time(index),[data.ion_i(index),data.ele_i(index)],'linewidth',2)
set(gca,'xlim',[t1 t2]);set(gca,'xtick',t1:t2);
%set(gca,'ylim',[-0.1 0.1]);
datetick('x','mm-dd','keepticks')
xlabel('时间','fontsize',12); ylabel('高压电流','fontsize',12);
grid on
legend('电子高压电流','离子高压电流')
text(0.1,0.9,'开机','units','normalized')

set(gcf,'color','w')
%saveas(gcf, '离子和电子高压', 'png');

%% 2
index = find(~strcmp(data.dc1,'--'));
dc1_str = char(data.dc1);   dc2_str = char(data.dc2);
dc1 = dc1_str(index,3:end); dc2 = dc2_str(index,3:end);
v1 = -732*(hex2dec(dc1)*5/65535)+347;
v2 = -740*(hex2dec(dc2)*5/65535)+354;
t1 = floor(data.time(index(1)));   t2 = ceil(data.time(index(end)));
scrsz = get(groot,'ScreenSize');
figure('Position',scrsz)
plot(data.time(index),[v1,v2],'linewidth',2)
set(gca,'xlim',[t1 t2]);set(gca,'xtick',t1:t2);
%set(gca,'ylim',[-0.1 0.1]);
datetick('x','mm-dd','keepticks')
xlabel('时间','fontsize',12); ylabel('差异电位','fontsize',12);
grid on
legend('差异电位传感器1','差异电位传感器2')
text(0.1,0.9,'开机','units','normalized')

set(gcf,'color','w')
%saveas(gcf, '差异电位', 'png');

%% 3
index = find(~isnan(data.highv1));
t1 = floor(data.time(index(1)));   t2 = ceil(data.time(index(end)));
scrsz = get(groot,'ScreenSize');
figure('Position',scrsz)

subplot(2,1,1)
plot(data.time(index),[data.highv1(index),data.highv2(index),data.highv3(index),data.highv4(index)],'linewidth',2)
set(gca,'xlim',[t1 t2]);set(gca,'xtick',t1:t2);
%set(gca,'ylim',[-0.1 0.1]);
datetick('x','mm-dd','keepticks')
xlabel('时间','fontsize',12); ylabel('高压检测','fontsize',12);
grid on
legend('离子主高压','离子MCP高压','电子主高压','电子MCP高压')
text(0.1,0.9,'开机','units','normalized')

subplot(2,1,2)
plot(data.time(index),[data.erciv1(index),data.erciv2(index),data.erciv3(index)],'linewidth',2)
set(gca,'xlim',[t1 t2]);set(gca,'xtick',t1:t2);
%set(gca,'ylim',[-0.1 0.1]);
datetick('x','mm-dd','keepticks')
xlabel('时间','fontsize',12); ylabel('二次电源检测','fontsize',12);
grid on
legend('二次电源检测1','二次电源检测2','二次电源检测3')
text(0.1,0.9,'开机','units','normalized')

set(gcf,'color','w')
%saveas(gcf, '高压检测', 'png');

%% 4 挑选所有的差异电位值
clear;clc;
filepath = 'D:\Softwares\MATLAB\CodeFile\';
file = dir([filepath,'*.mat']);

time = []; dc1 = []; dc2 = [];
for i = 1:length(file)
    load([filepath,file(i).name])
    time_temp = data.time; dc1_temp = data.dc1; dc2_temp = data.dc2;
    time = [time;time_temp];
    dc1 = [dc1;dc1_temp];
    dc2 = [dc2;dc2_temp];
end

time = time-8/24;   % 北京时间 -> UTC
index = find(~strcmp(dc1,{'--'}));
dc1_str = char(dc1(index));    dc2_str = char(dc2(index));
v1 = -732*(hex2dec(dc1_str(:,3:end))*5/65535)+347;
v2 = -740*(hex2dec(dc2_str(:,3:end))*5/65535)+354;
t = time(index);

t1 = datenum([2021 07 10 00 00 00]); t2 = datenum([2021 08 15 00 00 00]);
idx1 = find(t>t1 & t<t2);
time1 = t(idx1); v1_cut = v1(idx1); v2_cut = v2(idx1);
plot(time1,[v1_cut,v2_cut],'LineWidth',2)
datetick('x','mm-dd','keepticks')
set(gca,'xlim',[t1 t2])

% load('D:\Softwares\MATLAB\CodeFile\fy3e\rsp\data\fy3e_rsp_dc_global_data.mat')
% idx2 = find(dc_global_data.time>t1 & dc_global_data.time<t2);     time2 = t(idx2); 
% 
% glat_new = interp1(time2,dc_global_data.glat(idx2),time1);
% glong_new = interp1(time2,dc_global_data.glong(idx2),time1);
% 
% scrsz = get(groot,'ScreenSize');
% h = figure('Position',scrsz);
% worldmap('World')
% load coast
% hold on
% scatterm(glat_new,glong_new,2,v2(idx1),'filled');
% plotm(lat, long)
% drawnow
% set(gca,'clim',[4,10])
% colorbar; colormap(jet);



