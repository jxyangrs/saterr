function [w] = math_window(winopt,N)
% normalized window
%
% Example:
%   [w] = math_window('rectwin',7); rectwin/triang/etc
%
%   @bartlett       - Bartlett window.
%   @barthannwin    - Modified Bartlett-Hanning window. 
%   @blackman       - Blackman window.
%   @blackmanharris - Minimum 4-term Blackman-Harris window.
%   @bohmanwin      - Bohman window.
%   @chebwin        - Chebyshev window.
%   @flattopwin     - Flat Top window.
%   @gausswin       - Gaussian window.
%   @hamming        - Hamming window.
%   @hann           - Hann window.
%   @kaiser         - Kaiser window.
%   @nuttallwin     - Nuttall defined minimum 4-term Blackman-Harris window.
%   @parzenwin      - Parzen (de la Valle-Poussin) window.
%   @rectwin        - Rectangular window.
%   @taylorwin      - Taylor window.
%   @tukeywin       - Tukey window.
%   @triang         - Triangular window.
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, 10/16/2019: original code

switch winopt
    case {'rectwin','rectangle'}
        w = window(@rectwin,N);
        w = w(:)/sum(w);
    case {'triang','triangle'}
        w = window(@triang,N);
        w = w(:)/sum(w);
    otherwise
        eval(['w = window(@',winopt,',N);'])
        w = w(:)/sum(w);
end
