function prof_write_dailyinfo(outpath,outfile,len_orbit,idx_screen,time_sc)
% write files of atmospheric profiles and surfaces collocated w/ satellite FOV
% 
% Input:
%         outpath,              output path,                            string
%         outfile,              output filename,                        string
% 
% Output:
%         len_orbit,            No. of orbit lengths,                   [norbit,1]
%         idx_screen,           logical for screening (0=good,1=bad),   [norbit,1]
%         time_sc,              spacecraft time,                        [npixel,1]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/01/2020: original code


save([outpath,'/',outfile],'len_orbit','idx_screen','time_sc');

