function saterr_set_poloffset
% setting angle offset of reflector or feedhorn
% e.g., polarization offset can occur when a twistangle offset occurs for cross-track sensor
%
% Input:
%       setting polarization angular offset
% 
% Output:
%       offset_phi,             offset of cross-track scanning angle (degree),      scalar,     nominal phi=0 for crosstrack scanning
%       offset_theta,           offset of refletor normal angle (degree),           scalar,     nominal theta=45 for crosstrack scanning
%       offset_psi,             offset of polarization alignment angle (degree),    scalar,     nominal psi=90 for crosstrack scanning
%
% Description:
%     cross-track scanning
%       offset_phi,             offset of cross-track scanning angle (degree)
%       offset_theta,           offset of refletor normal angle (degree)
%       offset_psi,             offset of polarization alignment angle (degree)
%     conical scanning
%       offset_psi,             offset of polarization alignment angle (degree) resulting blended cross-pol
% 
%    used phi = nomial phi + offset_phi
%    used theta = nomial theta + offset_theta
%    used psi = nomial psi + offset_psi
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/31/2019: original code

global PolOffset Rad

% -----------------------------
% setting
% -----------------------------
PolOffset.onoff = 0; % 0=off,1=on

switch Rad.scantype
        
    case 'crosstrack' 
        offset_phi = 1; % offset of scan angle (degree)
        offset_theta = 1; % offset of refletor normal angle (degree)
        offset_psi = 1; % offset of polarization alignment angle (degree)
        
    case 'conical'
        offset_psi = 1; % offset of polarization alignment angle (degree)
        
    otherwise
        error('Error of PolOffset.emis.type')
end

% -----------------------------
% parse
% -----------------------------
saterr_parse_poloffset

