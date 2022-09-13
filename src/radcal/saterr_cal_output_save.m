function saterr_cal_output_savesingle(Path,outpath,outfile,...
    tas,tas_bias,tas_noise,taw_noise,tac_noise,tbs)
% save variables of single precision
%
% Input:
%       calibration processing
%
% Output:
%       tas,            scene antenna temperature,      [crosstrack(n-scene),alongtrack(n-scene),channel]
%       tas_bias,       tas bias,                       [crosstrack(n-scene),alongtrack(n-scene),channel]
%       tas_noise,      tas noise,                      [crosstrack(n-scene),alongtrack(n-scene),channel]
%       taw_noise,      taw noise,                      [crosstrack(n-warmload),alongtrack(n-warmload),channel]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/01/2019: original code

tas = single(tas);
tas_bias = single(tas_bias);
tas_noise = single(tas_noise);
taw_noise = single(taw_noise);
tac_noise = single(tac_noise);
tbs = single(tbs);

switch Path.scheme
    case 'A'
        save([outpath,'/',outfile],'tas','tas_bias','tas_noise','taw_noise','tac_noise','tbs')
    case 'B'
        save([outpath,'/',outfile],'tas','tas_bias','tas_noise','taw_noise','tac_noise','lat','lon','tbs')
        
end



