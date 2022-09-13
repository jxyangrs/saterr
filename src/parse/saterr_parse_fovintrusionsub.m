function y2 = saterr_parse_fovintrusionsub(x,y,spoil_fit)
% fit the edge-of-scan FOV intrusion w/ specific function
%
% default:
%     A*exp(-B*x)
% 
%     Antenna pattern of Gaussian function form is
%       G = exp(-4*ln2*(x^2/w1^2+y^2/w2^2))
%     The edge of scan blockage is
%       P(x<x1) = int(G,-inf<x<x1,-inf<y<inf)
%     when x1 is away from center (since fraction of FOV intrusion is usually very small)
%       P(x<x1) ~= A*exp(-B*(x-u)^2)
%     for very large x1, it further reduces to
%       P(x<x1) ~= A*exp(-B*(x-u)) == A*exp(-B*x)
%
% Overall, A*exp(-B*x) can well approximate FOV intrusion when it is small
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/21/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/11/2020: scheme 1
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/16/2019: parameterize fraction w/ Gaussian pattern

switch spoil_fit
    case 1 % y=A*exp(-B*x)
        idx = y>0.0001;
        x1 = x(idx);
        y1 = log(y(idx));
        p = polyfit(x1,y1,1);
        A = exp(p(2));
        B = -p(1);
        U = 0;
        
        y2 = A*exp(-B*x);
        
    case 2 % y=A*exp(-B*(x-u)^2)
        x0 = [0.1 1 0];
        xl = [0.001 0 -100];
        xu = [5 2  0];
        options = optimset('Display','off','MaxFunEvals',1000,'TolFun',.01);
        [z] = lsqnonlin(@(z) inv_exp2_v3(z,x,y),x0,xl,xu,options);
        
        A = z(1);
        B = z(2);
        U = z(3);
        
        y2 = A*exp(-B*x);
    otherwise 
        error('Error of spoil_fit')
end


function F = inv_exp2_v3(z,x,y)
y1 = z(1)*exp(-z(2)*(x-z(3)).^2);
F = y1-y;
