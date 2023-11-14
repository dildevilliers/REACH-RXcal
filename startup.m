% STARTUP Sets paths for REACH-RXcal package
% [] = startup() Sets the current path as the root for the package, and
% links all internal folders
%
% Inputs
% - 
%
% Outputs
%
% Dependencies
% -
%
% Created: 2023-11-14, Dirk de Villiers
% Updated: 2023-11-14, Dirk de Villiers
%
% Tested : Matlab R2022b, Dirk de Villiers
%  Level : 1
%   File : 
%

function startup

% get location of this file (toolbox root path)
p = mfilename('fullpath');
REACHroot = [fileparts(p),'\'];

% add matlab class paths
addpath(genpath([REACHroot,'Classes']))
addpath(genpath([REACHroot,'data']))
addpath(genpath([REACHroot,'testScripts']))
addpath(genpath([REACHroot,'utils']))
end
