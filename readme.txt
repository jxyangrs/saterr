% Microwave-radiometer SIMulator (MSIM) for diagnosing observation error and quantifying uncertainty propagation
%       The simulator can mimic a spaceborne total power radiometer w/ focus on RFIC noise and a range of error sources
%       Step1. simulating counts; Step2. converting count to antenna temperature (TA) and visualization
%
% Input:
%       Flexible setup and combination. See Examples and Program Layout for details.
%       All settings are made in scripts of "msim_set_*.m" under the directory of "./src/set/"
%
% Output:
%       count, TA, visualization
%
% Examples:
%     Step 1. simulation
%     a) simulation w/ orbital oscillation (w/ additive 1 K noise of 1/f and thermal noise, half half)
%       Setting.Rad.sensor = 'Demo_Oscillation'; % Demo_Oscillation/Demo_89GHz/MHS/Customize
%       Setting.Rad.spacecraft = ''; % optional, Metop-A
%       Setting.PathRoot = '.\demo\';
%       Setting.outfile = 'msim_1sim_test.mat';
%
%     b) simulation w/ noise in a orbit of MHS 89 GHz (w/ additive 1 K noise of 1/f and thermal noise, half half)
%       Setting.Rad.sensor = 'Demo_89GHz'; % Demo_Oscillation/Demo_89GHz/MHS/Customize
%       Setting.Rad.spacecraft = ''; % optional, Metop-A
%       Setting.PathRoot = '.\demo\';
%       Setting.outfile = 'msim_1sim_test.mat';
%
%     c) simulation for NOAA-19 MHS (w/ empirical noise)
%       Setting.Rad.sensor = 'MHS'; % Simple/MHS/Customize
%       Setting.Rad.spacecraft = 'Metop-A'; % optional
%       Setting.PathRoot = '.\demo\';
%       Setting.outfile = 'msim_1sim_test.mat';
%
%     d) customize simulation w/ your own parameters. Make changes accordingly in section of Settings
%       Setting.Rad.sensor = 'Customize'; %
%       Setting.Rad.spacecraft = ''; % optional, Simple/NPP/N20/Metop-A/Metop-C
%       Setting.PathRoot = '.\demo\';
%       Setting.outfile = 'msim_1sim_test.mat';
%
%     Step 2. calibration converting count to TA
%
% Program layout:
%                                                      rootpath
%                                  _______________________|________________________________
%                                  |                                        |             |
%                              src (source code)                           data          demo
%                                  |                                        |             |
%                                  |                                   sample orbits    examples
%     _____________________________|__________________________________________________________________________________________            
%     |            |              |             |           |             |          |            |              |           |    
%    set         parse           imp           main        noise         orbit      rtm           pol          utility     others   
%     |            |              |             |           |             |          |             |             |           |
%    setup     parse setup    implement      sim/cal    generating     orbit&geo  radiative    polarization    ancillary   additional modules    
%     |                                                   noise                    transfer      related                    (e.g. IGRF)
%     |
%   (setup and make all changes in scripts in the directory)
%
% Computer environment:
%       MATLAB version 2016b or later, supporting implicit expand for arithmetic operation
%
% Version:
%       V1.0, Feb. 2020
% 
% Author:
%       Dr. John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, Feb. 2020
%
