function [title,outputArg] = fy3e_rsp_l0_load(fileName)
% LOAD RSP L0 DATA
% Input: File Name
% Output: Array of Data (n*3), including time, PT1 and PT2
% The Order: time, PT1, PT2
% By Liu Bin, E-mail: liubin@nssc.ac.cn

title = [{'time'}, {'PT1'}, {'PT2'}];

fid = fopen(fileName,'r');
fseek(fid, 0, 'eof');
total_len = ftell(fid);    % length of this file
single_len = 25;
num = (total_len-256)/single_len;
data = zeros(num, 3);

for i = 1:num
    fseek(fid,(i-1)*single_len+256+3, 'bof');
    code_day = fread(fid,1, 'ubit16','b');    % 2 byte day
    code_ms = fread(fid,1, 'ubit32','b');     % 4 byte ms
    timetemp = code_day + datenum([2000 01 01 12 00 00]) + code_ms/1e3/3600/24;
    
    pt2_high = dec2hex(fread(fid,1, 'ubit32','b'),4);
    pt2_low = dec2hex(fread(fid,1, 'ubit32','b'),4);
    pt2 = -740 * hex2num([pt2_high, pt2_low]) + 354;
    
    pt1_high = dec2hex(fread(fid,1, 'ubit32','b'),4);
    pt1_low = dec2hex(fread(fid,1, 'ubit32','b'),4);
    pt1 = -732 * hex2num([pt1_high, pt1_low]) + 347;
    
    data(i,1) = timetemp;
    data(i,2) = pt1;
    data(i,3) = pt2;
end
fclose(fid);

outputArg = data;

end

