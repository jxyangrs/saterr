% parsing additive noise magnitude
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: noise setting
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/23/2019: type-chan sytax change

% -----------------------------
% parse
% -----------------------------
switch Noise.addnoise.source
    case {'demo','customize'} % Simple/customize
        % parse
        saterr_parse_noiseadditive_cust
        
    case {'amsr-e','amsr2','amsu-a','amsu-b','atms','gmi','mhs','mwri','mwhs-2','mwts-2','smap','ssmi','ssmis','tempest-d','tms'} % sensor
        % parse
        saterr_parse_noiseadditive_sensor
        
    otherwise
        error('Noise.source is wrong')
end


  