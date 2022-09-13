function ws = retr_wind_ssmi(tb_19v,tb_22v,tb_37v,tb_37h)
% atms temperature retrieval
% 
% Input:
%       tb_19v,     tb of channel 19v,                  [pixel,1]
%       tb_22v,     tb of channel 22v,                  [pixel,1]
%       tb_37v,     tb of channel 37v,                  [pixel,1]
%       tb_37h,     tb of channel 37h,                  [pixel,1]
% 
% Output:
%       ws,         surface wind speed (m/s)
% 
% Description:
%       Goodberlet et al., Ocean surface wind speed measurements of the Special Sensor Microwave/Imager (SSM/I)
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 8/6/2020


ws = 1.0969*tb_19v-0.4555*tb_22v-1.7600*tb_37v+0.7860*tb_37h+147.90;
