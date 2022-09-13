function saterr_parse_indCT
% parsing index of scanning position
%
% Input:
%       Radiometer setting of scanning
%
% Output:
%       Rad.ind_CT,         [cs,cc,cw,null]
%       Rad.ind_CT_num,     [cs,cc,cw,null]
%       Rad.ind_CTorder,    [cs,cc,cw,null],         (no blank interval)
%       Rad.ind_scan_name,  {'cs','cc','cw','null'}
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/03/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/19/2019: more index of crosstrack
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/19/2019: reorder starting w/ cs
global Rad

% index of cc,cw,cs,c_null
[ind1,ind2] = ind_startend_cum(Rad.num_crosstrack);

ind_cc = [];
ind_cw = [];
ind_cs = [];
ind_null = [];

for i=1: length(Rad.name_crosstrack)
    switch Rad.name_crosstrack{i}
        case 'cs'
            ind_cs = [ind_cs;[ind1(i),ind2(i)]];
            idx = logical(sum(isnan(ind_cs),2));
            ind_cs(idx,:) = [];
            if isempty(ind_cs)
                warning('cs is empty')
            end
        case 'cc'
            ind_cc = [ind_cc;[ind1(i),ind2(i)]];
            idx = logical(sum(isnan(ind_cc),2));
            ind_cc(idx,:) = [];
            if isempty(ind_cc)
                warning('cc is empty; cannot do calibration')
            end
        case 'cw'
            ind_cw = [ind_cw;[ind1(i),ind2(i)]];
            idx = logical(sum(isnan(ind_cw),2));
            ind_cw(idx,:) = [];
            if isempty(ind_cw)
                warning('cw is empty; cannot do calibration')
            end
        case 'null'
            ind_null = [ind_null;[ind1(i),ind2(i)]];
            idx = logical(sum(isnan(ind_null),2));
            ind_null(idx,:) = [];
            if isempty(ind_null)
                warning('null is empty')
            end
        otherwise
            error(['Rad.name_crosstrack is wrong: ',Rad.name_crosstrack{i}])
    end
end

ind_CT = {ind_cs,ind_cc,ind_cw,ind_null}; % cs,cc,cw,null
ind_CT = ind_startend_2ind(ind_CT);
ind_CT_num = [];
for i=1: size(ind_CT,2)
    ind_CT_num(i) = length(ind_CT{i});
end

Rad.ind_CT = ind_CT;
Rad.ind_CT_num = ind_CT_num;
Rad.ind_scan_name = {'cs','cc','cw','null'};

ind2 = cumsum(ind_CT_num);
ind1 = [1,ind2(1:end-1)+1];
Rad.ind_CTorder = []; % index w/o jump
for i=1: length(ind1)
    ind = ind1(i): ind2(i);
    Rad.ind_CTorder{i} = ind;
end

