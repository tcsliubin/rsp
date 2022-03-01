clear;clc;
filepath = 'E:\FY3E\data\科学数据\L1\RSP\DATA\';
file = dir([filepath,'*.HDF']);
time = []; alt = []; glat = []; glong = []; dp1 = []; dp2 = [];
glat_event = []; glong_event = []; dp1_event = [];

% load coast
% plot(long,lat,'linewidth',1); 
% set(gca,'xlim',[-60 60]);set(gca,'xtick',-60:30:60)
% set(gca,'ylim',[-90 0]);set(gca,'ytick',-90:15:0)
% xlabel('Longtitude [\circ]'); ylabel('Latitude [\circ]')
% grid on
% hold on
for i = 1:length(file)
    filename = file(i).name; 
    %h5disp([filepath,filename])
    [title_l1, data] = fy3e_rsp_l1_load([filepath,filename]);
    
    dp1_new = -732*((data(:,3)-354)/(-740))+347;
    dp2_new = -740*((data(:,2)-347)/(-732))+354;
    
    [dp1_min, sig] = min(dp1_new);
    glat_min = glat_temp(sig);  glong_min = glong_temp(sig);
        
    time = [time;time_temp];
    alt = [alt;alt_temp];
    glat = [glat;glat_temp];
    glong = [glong;glong_temp];
    dp1 = [dp1;dp1_new];
    dp2 = [dp2;dp2_new];
    
    dp1_event = [dp1_event;dp1_min];
    glat_event = [glat_event;glat_min];
    glong_event = [glong_event;glong_min];
% 
%     plot(time,[dp1_new,dp2_new])
%     latlim = [-89 89];
%     lonlim = [-180 180];
%     worldmap(latlim,lonlim)   
%     hold on

%     subplot(2,2,i-1)

%     dp1_new(end) = NaN;
%     patch(glong_temp,glat_temp,dp1_new,'EdgeColor','interp','MarkerFaceColor','none','linewidth',4);
%     plotm(lat, long)
%     drawnow
%     hold off
%     colorbar; colormap(flipud(jet));
%     title(['[DP2] ',timestr],'fontsize',12)
%     set(gca,'clim',[-200,0])
%     set(gcf,'color','w')
    
end
[time_plot, idx, ic] = unique(time);
dp1_plot = dp1(idx);
dp2_plot = dp2(idx);

dp1_plot(dp1_plot>100 | dp1_plot<-3000) = NaN;
dp2_plot(dp2_plot>100 | dp2_plot<-3000) = NaN;
index = find(time_plot>datenum([2021 07 18 00 00 00]));

scrsz = get(groot,'ScreenSize');
figure('Position',scrsz);
plot(time_plot(index),[dp1_plot(index),dp2_plot(index)],'linewidth',1.5)
t1 = datenum([2021 07 18]); t2 = datenum([2021 09 02]);
set(gca,'xtick',t1:5:t2);datetick('x','mm-dd','keepticks');set(gca,'xlim',[t1 t2]);
legend('探头1（背阳面）','探头2（向阳面）','fontsize',12,'Location','southeast')
grid on
xlabel('Date', 'fontsize',12)
ylabel('Differential Charging Potential [V]', 'fontsize',12)
set(gcf,'color','w')

%% plot(time,[dp1,dp2]);datetick('x','mm/dd','keepticks')
dp2_new(dp2_new>200) = NaN; dp1_new(dp1_new>100) = NaN;
figure('Position',scrsz);
axes('position',[0.1 0.1 0.8 0.8])
plot(time_plot,[dp1_plot,dp2_plot],'linewidth',1.5)
set(gca,'xtick',round(time(1)):5:round(time(end)))
datetick('x','mm/dd','keepticks')
set(gca,'xlim',[round(time(1)) round(time(end))+1])
% set(gca,'ydir','reverse')
set(gca,'ylim',[-250 50])
set (gca,'FontSize',18)
grid on
xlabel('Date','fontsize',18)
ylabel('Differential Charging Potential [V]','fontsize',18)
legend('PT1 (Anti-towards the Sun)','PT2 (Towards the Sun)','fontsize',16)
set(gcf,'color','w')

axes('position',[0.6 0.6 0.2 0.2])
plot(time_plot,[dp1_plot,dp2_plot],'linewidth',1.5)
set(gca,'xlim',[datenum([2021 08 03 22 30 00]) datenum([2021 08 03 23 00 00])])
set(gca,'xtick',datenum([2021 08 03 22 30 00]):5/60/24:datenum([2021 08 03 23 00 00]))
datetick('x','HH:MM','keepticks')
set(gca,'ylim',[-250 50],'ytick',-250:50:50)
% set(gca,'ydir','reverse')
grid on
set (gca,'FontSize',14)
xlabel('2021-08-03','fontsize',14)
ylabel('Differential Charging Potential [V]','fontsize',14)
% orbitdata.time = time; 
% orbitdata.alt = alt; orbitdata.glat = glat; orbitdata.glong = glong;
%%
% orbitdata.time = time; 
% orbitdata.alt = alt; orbitdata.glat = glat; orbitdata.glong = glong;
dp1_p = dp1_event;
dp1_p(dp1_p<-500 | dp1_p>-5) = NaN; 

scrsz = get(groot,'ScreenSize');
h = figure('Position',scrsz);
% latlim = [-89 89];
% lonlim = [-180 180];
% worldmap(latlim,lonlim) 
load coast
hold on
scatter(glong_event,glat_event,30,log10(dp1_p/(-1)),'filled');
plot(long,lat,'k')
% drawnow
box on
set (gca,'FontSize',18)
set(gca,'xlim',[-180 180],'xtick',-180:60:180,'ylim',[-90 90],'ytick',-90:30:90)
cb = colorbar; colormap(jet);
xlabel('Longtitude (\circ)','fontsize',16)
ylabel('Latitude (\circ)','fontsize',16)
ylabel(cb,{'Differential Charging Potential';'log_{10}([-V/V])'},'rotation',90,'fontsize',16)
set(gca,'clim',[0,2])
hold off
set(gcf,'color','w')
title('DP1','fontsize',16)

%save D:\Softwares\MATLAB\CodeFile\fy3e\data\fy3e_orbit_data_20210815 orbitdata
% dc_global_data.time = time;
% dc_global_data.alt = alt; dc_global_data.glat = glat; dc_global_data.glong = glong;
% dc_global_data.dp1 = dp1; dc_global_data.dp2 = dp2;

%save D:\Softwares\MATLAB\CodeFile\fy3e\rsp\data\fy3e_rsp_dc_global_data dc_global_data

