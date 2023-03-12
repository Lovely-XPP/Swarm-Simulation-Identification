%% init
clc;
clear;
addpath('utils')

%% sweep setting
sweep_amp = 1;
samplingrate = 100;
% 0.09 ~ 1.21
f0 = 0.09;
f1 = 1.21;
sweeptime = 60;
if f0 == 0.09 && f1 == 1.21
    sweeptime = 100;
end

%% simulation setting
stepsize = 0.01;
option = simset('fixedstep', stepsize);
simtime = 20 + sweeptime;
out = sim("quadrotor.slx", [0 simtime], option);

%% fig
fig(out, sweep_amp, f0, f1, 1)

%% identify
% identify(sweep_amp, f0, f1, 1)