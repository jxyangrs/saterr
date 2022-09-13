function tb_out = saterr_cal_conic_faraday(tb_in)
% correcting for Faraday rotation
%
% Input:
%       tb_in,         brightness temperature,      [crosstrack,alongtrack,channel]
%                      (w/ crosstalk)
%       CalPara.
%
% Output:
%       tb_out,        brightness tempereture,      [crosstrack,alongtrack,channel]
%                      (w/o crosstalk)
%
% Description:
%       A couple of schemes can be used
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code

global CalPara Rad

if CalPara.Faraday.onoff
    tb_out = tb_in;
    d = CalPara.Faraday.chan.d;
    U = CalPara.Faraday.chan.U;
    
    for nchan=1: Rad.num_chan
        tb1 = tb_in(:,:,nchan);
        ind = Rad.chanpol_ind(nchan);
        d1 = d(:,:,nchan);
        U1 = U(:,:,nchan);
        
        switch ind
            case 1 % V
                tb1 = tb1 + d1;
            case 2 % H
                tb1 = tb1 - d1;
            case 3 % 3
                tb1 = tb1 - U1;
            case 4 % 4
                tb1 = tb1;
            otherwise
                error(['Rad.chanpol_ind is wrong: ',num2str(ind)])
        end
        tb_out(:,:,nchan) = tb1;
    end
else
    tb_out = tb_in;
end
