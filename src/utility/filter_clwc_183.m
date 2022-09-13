function idx = filter_clwc_183(tb183_1,tb183_3,tb183_7,eia)
% a cloud filter using 183 GHz channels of crosstrack instrument like AMSU-B/ATMS
%
% Input (1D):
%       tb183_1,        tb of 183±1; 18
%       tb183_3,        tb of 183±3; 19
%       tb183_7,        tb of 183±7; 20
%       eia,            Earth incidence angle
%
% Output (1D):
%       idx, 1=cloud/precipitation,0=clear-sky
%
% Reference:
%       Buehler et al., Atmos. Chem. Phys. 2007, A cloud filtering method for microwave upper tropospheric humidity measurements
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/02/2017: original code

% filter 1
idx = tb183_7-tb183_1<0 | tb183_3-tb183_1<0;

% filter 2
eia_thre = [...
    0.55	1.65	2.75	3.85	4.95	6.05	7.15	8.25	9.35
    10.45	11.55	12.65	13.75	14.85	15.95	17.05	18.15	19.25
    20.35	21.45	22.55	23.65	24.75	25.85	26.95	28.05	29.15
    30.25	31.35	32.45	33.55	34.65	35.75	36.85	37.95	39.05
    40.15	41.25	42.35	43.45	44.55	45.65	46.75	47.85	48.95]';
eia_thre = eia_thre(:);
eia_thre = [0;eia_thre];
eia_thre(end) = 70;

tb_thre = [...
    240.1	240.1	240.1	240.1	240.1	240.1	240.1	239.9	239.9
    239.8	239.8	239.7	239.7	239.6	239.6	239.5	239.4	239.3
    239.2	239.2	239.1	239	238.8	238.7	238.6	238.5	238.3
    238.2	238	237.8	237.6	237.4	237.2	237	236.7	236.6
    236.4	236.1	235.8	235.5	235.2	234.9	234.4	233.9	233.3]';

for i=1:numel(eia_thre)-1
    idx1 = eia_thre(i)<= eia & eia<eia_thre(i+1);
    idx2 = tb183_1<=tb_thre(i);
    idx(idx1&idx2) = 1;
end



