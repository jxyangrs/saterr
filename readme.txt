% Microwave-radiometer Noise (MNoise) simulator for noise simulation, characterization and analysis
%       The simulator can mimic a spaceborne total power radiometer w/ focus on studying the impact of a range of noise
%       Step1. simulating counts, Step2. calibrating count to antenna temperature (TA) and visualization
%
% Input:
%       Flexible setup and combination. See Examples and Program Layout for details.
%       All advanced settings are made in msim_set_*.m under ./src/set/
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
%     c) simulation for Metop-A MHS (w/ empirical noise)
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
%                                         src (source code)                                          data         demo
%     ________________________________________|______________________________________                 |             |
%     |            |                  |                |           |                |                 |             |
%    set         parse               imp             main        noise           utility        a sample orbit  example plot
%     |            |                  |                |           |                |
%    setup       parse setup   implement&process    sim/cal     noise related   utility&ancillary
%     |
%   (make all changes here)
%
% Computer environment:
%       MATLAB 2016b version or later, supporting implicit expand for arithmetic operation
%
% Author:
%       John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, Feb. 2020