%% init
clc;
clear;
addpath('utils')
only_identify = true;


%% sweep setting
sweep_amp = 0.5;
samplingrate = 100;
% 0.09 ~ 1.21
f0 = 0.09;
f1 = 0.5;
sweeptime = 60;
if f0 == 0.09 && f1 == 1.21
    sweeptime = 100;
end


%% identification delay setting
delay_set = 0.2;


%% simulation setting
filename = sprintf("./identify/%.2f-%.2f-%.2f-%.0f/origin_data.mat", sweep_amp, f0, f1, sweeptime+20);
if ~only_identify || ~exist(filename, "file")
stepsize = 0.01;
option = simset('fixedstep', stepsize);
simtime = 20 + sweeptime;
out = sim("quadrotor.slx", [0 simtime], option);
else
    out = load(filename);
    out = out.data;
end


%% fig
fig(out, sweep_amp, f0, f1)

%% identify
identify(sweep_amp, f0, f1, delay_set)