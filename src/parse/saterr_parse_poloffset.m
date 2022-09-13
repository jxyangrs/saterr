% parsing polarization offset
%
%
% Output:
%       PolOffset.angle.*,   
%     cross-track scanning
%       offset_phi,             offset of cross-track scanning angle (degree),      scalar,    
%       offset_theta,           offset of refletor normal angle (degree),           scalar,     
%       offset_psi,             offset of polarization alignment angle (degree),    scalar,     
%       nominal_phi,            nominal cross-track scanning angle (degree),        scalar,     nominal phi=0 for crosstrack scanning
%       nominal_theta,          nominal refletor normal angle (degree),             scalar,     nominal theta=45 for crosstrack scanning
%       nominal_psi,            nominal polarization alignment angle (degree),      scalar,     nominal psi=90 for crosstrack scanning
%     conical scanning
%       offset_psi,             offset of polarization alignment angle (degree),    scalar,
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/31/2019: original code

% -----------------------------
% parse and set nominal angular parameters (not to change)
% -----------------------------

switch Rad.scantype
    
    case 'crosstrack'
        PolOffset.angle.offset_phi = offset_phi; % offset of scan angle (degree)
        PolOffset.angle.offset_theta = offset_theta; % offset of refletor normal angle (degree)
        PolOffset.angle.offset_psi = offset_psi; % offset of polarization alignment angle (degree)
        
        PolOffset.angle.nominal_phi = 'N/A'; % nominal scan angle (degree); N/A also indicates zero
        PolOffset.angle.nominal_theta = 45; % nominal refletor normal angle (degree)
        PolOffset.angle.nominal_psi = 90; % nominal polarization alignment angle (degree)
        
    case 'conical'
        PolOffset.angle.offset_psi = offset_psi; % offset of polarization alignment angle (degree)
        
    otherwise
        error('Error of Rad.scantype')
end


