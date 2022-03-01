clear;clc;
filepath = 'D:\Softwares\MATLAB\CodeFile\';
file = dir([filepath,'*.mat']);

time_temp = []; data_temp = [];
for i = 1:length(file)
    filename = file(i).name;
    load([filepath, filename])
    time_temp = [time_temp;data.time];
    data_temp = [data_temp;data.dc1,data.dc2];
end

index = find(~strcmp(data_temp(:,1),'--'));
dc1_str = char(data_temp(:,1));   dc2_str = char(data_temp(:,2));
dc1 = dc1_str(index,3:end); dc2 = dc2_str(index,3:end);
v1 = -732*(hex2dec(dc2)*5/65535)+347;
v2 = -740*(hex2dec(dc1)*5/65535)+354;

time = time_temp(index);
scrsz = get(groot,'ScreenSize');
figure('Position',scrsz);
subplot(211)
plot(time(10:end),[v1(10:end),v2(10:end)],'LineWidth',2);grid on
datetick('x','mm/dd','keepticks')
subplot(212)
plot(time(10:end),[v1(10:end)-v2(10:end)],'LineWidth',2);grid on
datetick('x','mm/dd','keepticks')

%%
scrsz = get(groot,'ScreenSize');
h = figure('Position',scrsz);

worldmap('World')
load coast
plotm(lat, long)
drawnow
hold on

scatterm();
colorbar; colormap(jet);