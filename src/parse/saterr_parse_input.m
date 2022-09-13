% parsing input
% 
% Input:
%       input setting
% 
% Output:
%       Rad.sensor,       radiometer,               string
%       Rad.spacecraft,   spacecraft name,          string
%       Path.pathout,     output directory,         string
%       Path.outfile,     output file,              string
%       Const,            constant
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/09/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/07/2019: parse input setting

% parse
Rad.sensor = lower(Setting.Rad.sensor);
Rad.spacecraft = lower(Setting.Rad.spacecraft);

% parse
if isempty(Rad.spacecraft)
   saterr_parse_scdefault 
end
Setting.Rad.spacecraft = Rad.spacecraft;

% load constants
saterr_const
