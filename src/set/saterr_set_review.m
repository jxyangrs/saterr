function saterr_set_review
% reviewing setting
%
% Input:
%       setting
%
% Output:
%       Checking and summarizing all of the settings
%
% Description:
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 05/07/2019: original code

global Setting Rad Noise Const Orbit TimeVarying TBsrc WarmLoad Reflector MirrorCold ScanBias PolOffset AP VarDynamic Prof Faraday Path NGranuel CalPara

% checking
if strcmp(Rad.sensor,'TVAC')
    Prof.onoff = 0;
    Orbit.onoff = 0;
end

if strcmp(Rad.sensor,'demo')
    Rad.spacecraft = 'Demo';
end


% displaying
str_onoff = {'Off','On'};
disp('================================================')
disp('A summary of setting:')
disp('================================================')

disp(['Radiometer working mode is: ',AP.mode])
disp(['Radiometer is: ',Rad.spacecraft,', ',Rad.sensor,', ',Rad.scantype])

str1 = strcat(Rad.chan_freq_nominal,Rad.chanpol);
str2 = '';
for i=1: length(str1)
    if i==1
        str2 = str1{i};
    else
        str2 = [str2,',',str1{i}];
    end
end
disp(['Channel: ',str2])
disp(['Orbit is: ',str_onoff{Orbit.onoff+1}])
disp(['Atmospheric profile is: ',str_onoff{Orbit.onoff+1}])

disp(['target for the mainlobe is: ',num2str(AP.tbsrc.mainlobe)])
if AP.onoff == 1
    disp(['target for the sidelobe is: On; ',num2str(AP.tbsrc.sidelobe)])
    disp(['target for the spillover is: On; ',num2str(AP.tbsrc.spillover)])
else
    disp(['target for the sidelobe is: Off'])
    disp(['target for the spillover is: Off'])
end

disp(['spacecraft attitude offset is: ',str_onoff{Orbit.attitude.onoff+1}])
disp(['receiver additive noise is: ',str_onoff{Noise.addnoise.onoff+1}])
disp(['receiver shot noise is: ',str_onoff{Noise.shotnoise.onoff+1}])
disp(['receiver noise temperature dependence is: ',str_onoff{Noise.scene_tmpdep.onoff+1}])
disp(['receiver nonlinearity is: ',str_onoff{Rad.nonlinear.onoff+1}])
disp(['receiver crosspol contamination is: ',str_onoff{AP.crosspol.onoff+1}])
disp(['receiver crosstalk is: ',str_onoff{Rad.crosstalk.onoff+1}])
disp(['receiver spectral response is: ',str_onoff{Rad.sr.onoff+1}])
disp(['receiver twist angle offset is: ',str_onoff{PolOffset.onoff+1}])
disp(['receiver orbital oscillation is: ',str_onoff{TimeVarying.oscillation.onoff+1}])

disp(['warmload error is: ',str_onoff{WarmLoad.error.onoff+1}])
disp(['PRT noise is: ',str_onoff{Noise.PRT.onoff+1}])
disp(['cold-space mirror emission is: ',str_onoff{MirrorCold.error.onoff+1}])
disp(['FOV intrusion is: ',str_onoff{ScanBias.fovintrusion.onoff+1}])
disp(['instrument intereference is: ',str_onoff{ScanBias.interference.onoff+1}])

disp(['Faraday rotation is: ',str_onoff{Faraday.onoff+1}])
disp(['See setting variables for details'])
disp([' '])






