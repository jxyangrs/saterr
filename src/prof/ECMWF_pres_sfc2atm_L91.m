function [atm_pres_interface,atm_pres_level] = ECMWF_pres_sfc2atm_L91(sfc_pres)
% convert surface pressure to atmospheric pressure w/ 91 level, 92 interface
%
% Input:
%       sfc_pres, [lat,lon] (Pa)
% 
% Output:
%       atm_pres_interface, [lat,lon,92-layer(up-down)] (Pa)
%       atm_pres_level, [lat,lon,91-layer(up-down)] (Pa)
% 
% Note:
%       In ECMWF, level is between interface, https://rda.ucar.edu/datasets/ds627.0/docs/Eta_coordinate/
% 
%       In CRTM, there is layer=level of ECMWF, level=interface
%       MiRS use this code and average level pressure for layer pressure
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/14/2017: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 05/16/2018: refine
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/22/2019: help and ECMWF site thread
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 05/19/2020: add log average

ECMWFA=...
    [0.000000,2.000040,3.980832,7.387186,12.908319,21.413612,33.952858,51.746601, ...
    76.167656,108.715561,150.986023,204.637451,271.356506,352.824493,450.685791, ...
    566.519226,701.813354,857.945801,1036.166504,1237.585449,1463.163940,1713.709595, ...
    1989.874390,2292.155518,2620.898438,2976.302246,3358.425781,3767.196045,4202.416504, ...
    4663.776367,5150.859863,5663.156250,6199.839355,6759.727051,7341.469727,7942.926270, ...
    8564.624023,9208.305664,9873.560547,10558.881836,11262.484375,11982.662109,12713.897461, ...
    13453.225586,14192.009766,14922.685547,15638.053711,16329.560547,16990.623047,17613.281250, ...
    18191.029297,18716.968750,19184.544922,19587.513672,19919.796875,20175.394531,20348.916016, ...
    20434.158203,20426.218750,20319.011719,20107.031250,19785.357422,19348.775391,18798.822266, ...
    18141.296875,17385.595703,16544.585938,15633.566406,14665.645508,13653.219727,12608.383789, ...
    11543.166992,10471.310547,9405.222656,8356.252930,7335.164551,6353.920898,5422.802734, ...
    4550.215820,3743.464355,3010.146973,2356.202637,1784.854614,1297.656128,895.193542, ...
    576.314148,336.772369,162.043427,54.208336,6.575628,0.003160,0.000000];
ECMWFB=...
    [0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, ...
    0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, ...
    0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000,0.000000, ...
    0.000000,0.000000,0.000000,0.000000,0.000000,0.000014,0.000055,0.000131,0.000279,0.000548, ...
    0.001000,0.001701,0.002765,0.004267,0.006322,0.009035,0.012508,0.016860,0.022189,0.028610, ...
    0.036227,0.045146,0.055474,0.067316,0.080777,0.095964,0.112979,0.131935,0.152934,0.176091, ...
    0.201520,0.229315,0.259554,0.291993,0.326329,0.362203,0.399205,0.436906,0.475016,0.513280, ...
    0.551458,0.589317,0.626559,0.662934,0.698224,0.732224,0.764679,0.795385,0.824185,0.850950, ...
    0.875518,0.897767,0.917651,0.935157,0.950274,0.963007,0.973466,0.982238,0.989153,0.994204, ...
    0.997630,1.000000];

a(1,1,:) = ECMWFA;
b(1,1,:) = ECMWFB;

atm_pres_interface = bsxfun(@plus,a, bsxfun(@times,b,sfc_pres));

if 1
    % arithmetic average
    atm_pres_level = (atm_pres_interface(:,:,1:end-1) + atm_pres_interface(:,:,2:end))/2;
else
    % log average (Simmons and Burridge, 1981, Mon. Wea. Rev.; Trenberth, 1993, NCAR Technical Note)
    atm_pres_level = (atm_pres_interface(:,:,2:end)-atm_pres_interface(:,:,1:end-1))./log(atm_pres_interface(:,:,2:end)./atm_pres_interface(:,:,1:end-1));
    atm_pres_level(:,:,1) = atm_pres_interface(:,:,2)/2;
end


