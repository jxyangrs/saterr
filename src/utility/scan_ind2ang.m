function [scan_angall,scan_angcenter,scan_angstart,scan_angend,ind1,ind2] = scan_ind2ang(scan_num,scan_name)
% scanning angle to position index and number
% scanning coordinate is left-hand w/ nadir as zero
%
% Example:
%       scan_num = [221,98,13,84,13,71]; % gmi
%       scan_name = {'cs','null','cw','null','cc','null'};
%       [scan_angall,scan_angcenter,scan_angstart,scan_angend,ind1,ind2] = scan_ind2ang
% 
% Note:
%       Working well for conical scanning.
%       For cross-track scanning, conversing from ind to angle has large error since scanning speed is different for valid and null positions
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/28/2019: original code


% -----------------------------
% execute
% -----------------------------
angstep = 360/sum(scan_num);

n = sum(scan_num);
scan_angall = angstep*(0:n-1);
scan_angall = scan_angall-(scan_num(1)-1)/2*angstep;

ind = cumsum(scan_num);
ind1 = [1,ind(1:end-1)+1];
ind2 = ind;

for i=1: length(scan_num)
    t = scan_angall(ind1(i):ind2(i));
    scan_angstart(i) = t(1);
    scan_angend(i) = t(end);
    scan_angcenter(i) = (scan_angstart(i)+scan_angend(i))/2;
end

% -----------------------------
% plot
% -----------------------------
ind = ~cellfun(@isempty,strfind(scan_name,'cs'));
scan_angstart_duty(1) = scan_angstart(ind); % order of cs,cc,cw
scan_angend_duty(1) = scan_angend(ind); % order of cs,cc,cw
ind = ~cellfun(@isempty,strfind(scan_name,'cc'));
scan_angstart_duty(2) = scan_angstart(ind); % order of cs,cc,cw
scan_angend_duty(2) = scan_angend(ind); % order of cs,cc,cw
ind = ~cellfun(@isempty,strfind(scan_name,'cw'));
scan_angstart_duty(3) = scan_angstart(ind); % order of cs,cc,cw
scan_angend_duty(3) = scan_angend(ind); % order of cs,cc,cw

plot_color = {'g','b','r'};

% plot and verify
% alpha -> -alpha-90
figure(1)
plot_circle
daspect([1 1 1])
hold on

for i=1: length(scan_angstart_duty)
    alpha = -scan_angstart_duty(i)-90;
    x = cosd(alpha);
    y = sind(alpha);
    h3(i) = plot([0,x],[0,y],'color',plot_color{i});
end
legend(h3,{'Earth','Cold','Warm'})

for i=1: length(scan_angend_duty)
    alpha = -scan_angend_duty(i)-90;
    x = cosd(alpha);
    y = sind(alpha);
    plot([0,x],[0,y],'color',plot_color{i})
end

return


function plot_circle
q = 0:0.01:2*pi; % angle 0 to 360 degrees in radian
r = 1;          % radius
x = r*cos(q);    % cartesian x coordinate
y = r*sin(q);    % cartesian y coordinate
plot(x,y,'k')


