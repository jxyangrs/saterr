% parse reflector emission
%
%
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/01/2019: original code

% -------------------------
% parse and check
% -------------------------
if Reflector.emission.onoff
    % check
    n = size(Reflector.emission.E);
    if ~isequal(n,[4,n1])
        error('Error of size of Reflector.emission.E')
    end
    n = size(Reflector.emission.tmp);
    if ~isequal(n,[1,1])
        if ~isequal(n,[1,n2])
            error('Error of size of Reflector.emission.tmp')
        end
    end
    
else
    % setting not to change
    n1 = Rad.num_chan;
    n2 = Rad.num_alongtrack;
    Reflector.emission.E = zeros(4,n1); % emissivity of V-pol, H-pol, [Ev&Eh,channel], Ev>Eh, defined in reflection plane that is perpendicular to cross-track plane
    Reflector.emission.tmp = zeros(1,n2); % reflector physical temperature (Kelvin), [1,along-track]
    
end

