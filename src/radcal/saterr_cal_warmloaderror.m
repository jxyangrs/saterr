function Tw = saterr_cal_warmloaderror(Tw)
% correcting for warmload error
%
% Input:
%       Tw,         warmload PRT temperature,           [channel,crosstrack,alongtrack]
%       CalPara.
%
% Output:
%       Tw,         warmload calibration temperature,   [channel,crosstrack,alongtrack]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code

global CalPara

if CalPara.warmload.error.onoff == 1
    a = CalPara.warmload.error.slope; % [1,channel]
    b = CalPara.warmload.error.slope; % [1,channel]
    
    a1 = [];
    a1(1,1,:) = a;
    b1 = [];
    b1(1,1,:) = b;
    
    Tw = bsxfun(@plus, bsxfun(@times,Tw,a1), b1);
    
end

