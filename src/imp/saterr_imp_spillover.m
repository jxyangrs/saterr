function Tas = saterr_imp_spillover(tb_nonspillover,tb_spillover,nchan)
% applying spillover
% 
% tb = frac1*tb_nonspillover + frac2*tb_spillover
% 
% Input:
%       tb_nonspillover,   Stokes  spillover,           [Stokes,crosstrack,alongtrack]
%       tb_spillover,      Stokes of spillover,         [Stokes,crosstrack,alongtrack]
%       nchan,             channel number,              channel number
% 
% Output:
%       Tas,               Stokes w/ spillover,        [Stokes,crosstrack,alongtrack]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code

global AP

frac_main = AP.frac.mainlobe(:,:,:,nchan);
frac_side = AP.frac.sidelobe(:,:,:,nchan);
frac_spillover = AP.frac.spillover(:,:,:,nchan);

Tas = bsxfun(@plus, bsxfun(@times,tb_nonspillover,(frac_main+frac_side)),  bsxfun(@times,tb_spillover,frac_spillover));


