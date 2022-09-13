% calibration output
%
% Input:
%       calibration processing
%
% Output:
%       tas,            scene antenna temperature,      [crosstrack(n-scene),alongtrack(n-scene),channel]
%       tas_bias,       tas bias,                       [crosstrack(n-scene),alongtrack(n-scene),channel]
%       tas_noise,      tas noise,                      [crosstrack(n-scene),alongtrack(n-scene),channel]
%       taw_noise,      taw noise,                      [crosstrack(n-warmload),alongtrack(n-warmload),channel]
%       tbs,            scene brightness temperature,   [crosstrack(n-scene),alongtrack(n-scene),channel]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/01/2019: original code

outfile = strrep(infile,'sim_count_','cal_tatb_');
disp(outfile)
switch Path.scheme
    case 'A'
        outpath = [Path.cal.output,'/',ndatestr1(1:4),'/',ndatestr1];
    case 'B'
        outpath = [Path.cal.output,'/',ndatestr1(1:4),'/',ndatestr1];
end

if ~exist(outpath,'dir')
    mkdir(outpath);
end

saterr_cal_output_save(Path,outpath,outfile,...
    tas,tas_bias,tas_noise,taw_noise,tac_noise,tbs)



