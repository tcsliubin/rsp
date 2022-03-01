clear;clc;
filepath = 'E:\FY3E\data\科学数据\L0\RSP\DATA\';
filelist = dir([filepath,'*.DAT']);
len = length(filelist);

time = []; pt1 = []; pt2 = []; alt = []; long = []; lat = [];
for i = 1%:len
    filename = [filepath,filelist(i).name];
    [title_l0,pt_data] = fy3e_rsp_l0_load(filename);
    
    time = [time; pt_data(:,1)];
    pt1 = [pt1; pt_data(:,2)];
    pt2 = [pt2; pt_data(:,3)];
    
%     alt = [alt; pt_data(:,1)];
%     long = [long; pt_data(:,1)];
%     lat = [lat; pt_data(:,1)];
end

pt1(pt1>100 | pt1<-3000) = NaN;   pt2(pt2>100 | pt2<-3000) = NaN;
t1 = datenum([2021 07 18 00 00 00]); t2 = datenum([2022 02 12 00 00 00]);
t_delta = 10;

%% Plot
scrsz = get(groot,'ScreenSize');
figure('Position',scrsz);
h = plot(time, [pt1,pt2], 'linewidth', 1.5);
set(gca, 'xtick', t1:t_delta:t2)
datetick('x','mm/dd', 'keepticks')
set(gca, 'xlim', [t1 t2])
set(gca, 'ytick', -200:50:50, 'ylim', [-200 50], 'fontsize', 16, 'Position', [0.07 0.10 0.92 0.85])
title('FY3E RSP PT1/PT2','fontsize',16)
xlabel('Date','fontsize',16)
ylabel('Differential Charging Potential [V]','fontsize',16)
legend('PT1 (Anti-towards the Sun)','PT2 (Towards the Sun)','fontsize',16)
grid on
set(gcf, 'color', 'w', 'Position', [1 49 1280 681.50])



