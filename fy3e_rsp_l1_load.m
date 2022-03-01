function [title,outputArg] = fy3e_rsp_l1_load(fileName)
% LOAD RSP L1 DATA
% Input: File Name
% Output: Array of Data (n*9), including time, PT1 and PT2, position(altitude, longtitude, latitude, L value, mlat and mlong)
% The Order: time, PT1, PT2, altitude, latitude, longtitude, L value, mlat and mlong
% By Liu Bin, E-mail: liubin@nssc.ac.cn

title = [{'time'}, {'PT1'}, {'PT2'}, {'altitude'}, {'latitude'}, {'longtitude'}, {'L value'}, {'mlat'}, {'mlong'}];

year = h5read(fileName,'/Time/Year'); 
month = h5read(fileName,'/Time/Month'); 
day = h5read(fileName,'/Time/Date');
hour = h5read(fileName,'/Time/Hour'); 
minute = h5read(fileName,'/Time/Minute'); 
second = h5read(fileName,'/Time/Second');
time = datenum(double([single(year),single(month),single(day),single(hour),single(minute),second]));

dp1 = h5read(fileName,'/Data/DP1'); 
dp2 = h5read(fileName,'/Data/DP2'); 

alt = h5read(fileName,'/Geo/Alt.'); 
glat = h5read(fileName,'/Geo/GLAT'); 
glong = h5read(fileName,'/Geo/GLONG'); 
lvalue = h5read(fileName,'/Geo/L-Value'); 
mlat = h5read(fileName,'/Geo/MLAT'); 
mlong = h5read(fileName,'/Geo/MLONG'); 

num = length(year);
data = zeros(num, 9);
data(:,1) = time;  data(:,2) = dp1;   data(:,3) = dp2;
data(:,4) = alt;   data(:,5) = glat;  data(:,6) = glong;
data(:,7) = lvalue;  data(:,8) = mlat;   data(:,9) = mlong;

outputArg = data;

end

