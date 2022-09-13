function saterr_cal_para_parse_spillover
% cross-channel correlation
%
% Input:
%       CalPara.AP.frac.mainlobe,       [Stokes,crosstrack,alongtrack,channel]
%       CalPara.AP.frac.sidelobe,       [Stokes,crosstrack,alongtrack,channel]
%       CalPara.AP.frac.spillover,      [Stokes,crosstrack,alongtrack,channel]
%       CalPara.AP.tb.spillover,        [Stokes,crosstrack,alongtrack,channel]
%
% Output:
%       CalPara.AP.frac.mainlobe,       [crosstrack,alongtrack,channel]
%       CalPara.AP.frac.sidelobe,       [crosstrack,alongtrack,channel]
%       CalPara.AP.frac.spillover,      [crosstrack,alongtrack,channel]
%       CalPara.AP.tb.spillover,        [crosstrack,alongtrack,channel]
%               
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/01/2019: original code
global CalPara Rad

n1 = size(CalPara.AP.frac.mainlobe,1);
n2 = size(CalPara.AP.frac.mainlobe,2);
n3 = size(CalPara.AP.frac.mainlobe,3);
n4 = size(CalPara.AP.frac.mainlobe,4);
n = [n2,n3,n4];

frac_mainlobe = zeros(n);
frac_sidelobe = zeros(n);
frac_spillover = zeros(n);


n1 = size(CalPara.AP.tb.spillover,1);
n2 = size(CalPara.AP.tb.spillover,2);
n3 = size(CalPara.AP.tb.spillover,3);
n4 = size(CalPara.AP.tb.spillover,4);
n = [n2,n3,n4];
tb_spillover = zeros(n);

for nchan=1: Rad.num_chan
    ind = Rad.chanpol_ind(nchan);
    
    t = CalPara.AP.frac.mainlobe(ind,:,:,nchan);
    frac_mainlobe(:,:,nchan) = t;
    
    t = CalPara.AP.frac.sidelobe(ind,:,:,nchan);
    frac_sidelobe(:,:,nchan) = t;
    
    t = CalPara.AP.frac.spillover(ind,:,:,nchan);
    frac_spillover(:,:,nchan) = t;
    
    t = CalPara.AP.tb.spillover(ind,:,:,nchan);
    tb_spillover(:,:,nchan) = t;
    
end

CalPara.AP.frac.mainlobe = frac_mainlobe;
CalPara.AP.frac.sidelobe = frac_sidelobe;
CalPara.AP.frac.spillover = frac_spillover;
CalPara.AP.tb.spillover = tb_spillover;
