function ind_all = ind_startend_2ind(ind_startend)
% all index from start and end
%
% Example:
%       ind_all = ind_startend_2ind({[1,2],[3,5]})
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/11/2018: original code

ind_all = [];
for i=1: length(ind_startend)
    ind_seg = ind_startend{i};
    if isempty(ind_seg)
        ind = [];
    else
        ind1 = ind_seg(:,1);
        ind2 = ind_seg(:,2);
        ind = [];
        for j=1: size(ind1,1)
            ind = [ind, ind1(j): ind2(j)];
        end
    end
    ind_all{i} = ind;
end
