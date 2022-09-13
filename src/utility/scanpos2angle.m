function scanangle = scanpos2angle(sensor)
% convert scanposition to scanangle for cross-track scanning radiometer
%
% sensor
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/23/2017: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 04/20/2018: add parameters

% empirical parameters

switch sensor
    case 'amsu-a'
        num_scanpos = 30;
        angularres = 3.333;
    case 'atms'
        num_scanpos = 96;
        angularres = 1.11;
    case 'mhs'
        num_scanpos = 90;
        angularres = 1.11;
    otherwise
        error('Sensor not found')
end

% -----------------------------
% implement
% -----------------------------
n = num_scanpos;
scanangle = -(n-1)/2*angularres+(0:n-1)*angularres;
