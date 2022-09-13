function y = humconvert(opt,x,varargin)
% humidity conversion between relative humidity, specific humidity, absolute humidity, and mixing ratio
% 
% Input:
%       opt,        option,                             RH2SH/SH2AH/SH2RH/SH2MR/MR2SH
%       x,          variable to convert,                RH/SH/AH/MR
%       varargin,   ancillary,                          temperature (K), pressure (Pa),
%       Unit: T(K),P(Pa),RH(%),SH(kg/kg),AH(kg/m3),MR(kg/kg)
% 
% Output:
%       y,          converted humidity,                 RH/SH/AH/MR
% 
% Examples:
%       SH = humconvert('RH2SH',RH,T,P); % T(K), P(Pa); relative hum. to specific hum.
%       SH = humconvert('SH2RH',SH,T,P); % T(K), P(Pa); specific hum. to relative hum.
%       MR = humconvert('SH2MR',SH); % specific hum. to mixing ratio
%   
% Equations:
%       1) relative humidity to absolute humidity
%         Tc = T-273.15; % change from Kelvin to Celcius
%         es = 6.112*exp(17.67*Tc./(Tc+243.5))*10^2; %saturation vapor pressure (Pa)
%         e = 0.01*RH.*es; % vapor pressure (Pa)
%         Rv = 461.5; % constant (J/kg/K)
%         q = e./(Rv*T); % absolute humidity (kg/m3)
%         q(q<0)=0;
%
%       2) absolute humidy to specific humidity
%         Rv = 461.5; %constant, J/kg/K
%         e = q.*Rv.*T; %vapor pressure in Pa
%         humspc = e*0.622./P;
%
%       3) specific humidy to relative humidity (%)
%         Tc=T-273.15; % Celsius
%         es = 6.112*exp((17.67*Tc)./(Tc+243.5)); % saturation water pressure (Pa)
%         e = humspc.*(P/100)./(0.378*humspc+0.622); % water pressure (Pa)
%         RH = e./es*100; % relative humidity, %
%
%       4) specific humidy to absolute humidity
%         e = humspc.*P/0.622; %vapor pressure in Pa
%         Rv = 461.5; %constant, J/kg/K
%         q = e./(Rv*T); %absolute humidity, kg/m3
%         q(q<0)=0;
% 
%       5) specific humidity to mixing ratio
%               SH = Mw/(Md+Mw);
%               MR = Mw/Md;
%           where Mw=mass of water vapor, Md=mass of dry air
%         if SH is in unit of g/g or kg/kg, 
%               MR = SH/(1-SH)
%         if SH is in unit of g/kg, 
%               MR = SH/(1-0.001*SH)
% 
%       6) mixing ratio to specific humidity 
%               SH = Mw/(Md+Mw);
%               MR = Mw/Md;
%           where Mw=mass of water vapor, Md=mass of dry air
%         if SH is in unit of g/g or kg/kg, 
%               SH = MR/(1+MR)
%         if SH is in unit of g/kg, 
%               SH = MR/(1+0.001*MR)
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/17/2017: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/20/2018: SH/MR

if length(varargin)==2
    T = varargin{1};
    P = varargin{2};
end

switch opt
    case 'RH2SH'
        RH = x;
        
        % relative humidity to specific humidity
        Tc = T-273.15; % change from Kelvin to Celcius
        es = 6.112*exp(17.67*Tc./(Tc+243.5))*10^2; %saturation vapor pressure (Pa)
        e = 0.01*RH.*es; % vapor pressure (Pa)
        humspc = e*0.622./P;
        
        humspc(humspc<0)=0;
        y = humspc;
    case 'RH2AH'
        RH = x;
        
        % relative humidity to absolute humidity
        Tc = T-273.15; % change from Kelvin to Celcius
        es = 6.112*exp(17.67*Tc./(Tc+243.5))*10^2; %saturation vapor pressure (Pa)
        e = 0.01*RH.*es; % vapor pressure (Pa)
        Rv = 461.5; % constant (J/kg/K)
        q = e./(Rv*T); % absolute humidity (kg/m3)
        q(q<0)=0;
        
        y = q;
    case 'SH2AH'
        humspc = x;
        
        % specific humidy to absolute humidity
        e = humspc.*P/0.622; %vapor pressure in Pa
        Rv = 461.5; %constant, J/kg/K
        q = e./(Rv*T); %absolute humidity, kg/m3
        q(q<0)=0;
        
        y = q;
    case 'SH2RH'
        humspc = x;
        
        % specific humidy to relative humidity (%)
        Tc=T-273.15; % Celsius
        es = 6.112*exp((17.67*Tc)./(Tc+243.5)); % saturation water pressure (Pa)
        e = humspc.*(P/100)./(0.378*humspc+0.622); % water pressure (Pa)
        RH = e./es*100; % relative humidity, %
        
        y = RH;
    case 'SH2MR'
        y = x./(1-x);
    case 'MR2SH'
        y = x./(1+x);
    otherwise
        error('Input option is wrong')
end


