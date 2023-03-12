function identify(amplitude, f0 ,f1, h, delay)
%% setttings
% save setting
save_switch = true;
sweeptime = 60;
if f0 == 0.09 && f1 == 1.21
    sweeptime = 100;
end
% identify delay setting
observe_delay_sample = 100;


%% load data
data = load_data(amplitude, f0, f1, sweeptime, h);
in = data.in;
t = data.t;
out_p = data.out_p;
out_v = data.out_v;
[fidx, bidx] = clip_zero_data(in);
out_p = out_p(fidx:bidx);
out_p = out_p - out_p(1);
out_v = out_v(fidx:bidx);
t = t(fidx:bidx);
in = in(fidx:bidx);
t = t - t(1);
t_max = max(t);
p_min = min(out_p);
p_max = max(out_p);


%% Estimate v_cmd -> p
data_vp = iddata(out_p, in, 0.01);
data_vv = iddata(out_v, in, 0.01);
tf_vp = tfest(data_vp, 2, 0, delay);
[res_vp, fit_vp, ~] = compare(tf_vp, data_vp);
res_vp = res_vp.OutputData;
% v_cmd -> p -> v
tf_vp_num = tf_vp.Numerator;
tf_vp_den = tf_vp.Denominator;
tf_vp_delay = tf_vp.IODelay;
root = roots(tf_vp_den);
tf_vpv_den = [1 max(-root)];
tf_vpv = idtf(tf_vp_num, tf_vpv_den, 'IOdelay', tf_vp_delay);
[res_vpv, fit_vpv, ~] = compare(tf_vpv, data_vv);
res_vpv = res_vpv.OutputData;

%% Estimate v_cmd -> v
tf_vv = tfest(data_vv, 1, 0, delay);
[res_vv, fit_vv, ~] = compare(tf_vv, data_vv);
res_vv = res_vv.OutputData;

%% Generate p_cmd by integral
tf_int = idtf(1,[1, 0]);
res_int = sim(tf_int, data_vv);
res_int = res_int.Outputdata;


%% plot
txt = sprintf("Amplitude: %.2f     Frequncy: %.2f ~ %.2f     SweepTime: %.0f", amplitude, f0, f1, sweeptime);
img = figure('Name','SineSweep','Units','centimeters', 'Pos',[14 5 28 14], 'Name', "Identification Result");
tg = uitabgroup;
% Observe delay
tab = uitab(tg,'title', "Delay Observe");
axes('Parent',tab);
observe_delay_sample = observe_delay_sample + 1;
plot(t(1:observe_delay_sample), res_int(1:observe_delay_sample), "LineWidth", 2);
hold on;
plot(t(1:observe_delay_sample), out_p(1:observe_delay_sample), "LineWidth", 2);
obs_p_min = min(out_p(1:observe_delay_sample));
obs_p_max = max(out_p(1:observe_delay_sample));
y_min = 0;
if obs_p_min < 0
    y_min = obs_p_min;
end
axis([0, t(observe_delay_sample), y_min*2, obs_p_max*1.2])
xticks(0:0.1:t(observe_delay_sample));
xlabel('Time (second)');
ylabel('Position (m)');
grid on;
title(txt)
legend("CMD", "Real", 'FontName', 'Times New Roman', 'FontSize', 16, 'Location', 'northwest');
set(gca, 'FontName','Times New Roman', 'FontSize',16);
% v_cmd -> p
tab = uitab(tg,'title', "v_cmd -> p");
axes('Parent',tab);
plot(t, res_int, "LineWidth", 2);
hold on;
plot(t, out_p, "LineWidth", 2, 'Color','#EDB120');
plot(t, res_vp, '--', "LineWidth", 2, 'Color','#7E2F8E');
axis([0, t_max, p_min*1.2, p_max*1.2])
xticks(0:5:t_max);
xlabel('Time (second)');
ylabel('Position (m)');
grid on;
model_txt = sprintf("Model (Fit: %.2f %%)", fit_vp);
legend("CMD", "Real", model_txt, 'FontName', 'Times New Roman', ...
    'FontSize', 16, 'Location', 'north', 'Orientation', 'horizontal', 'NumColumns', 3);
title(txt)
set(gca, 'FontName','Times New Roman', 'FontSize',16);
% v_cmd -> p -> v
tab = uitab(tg,'title', "v_cmd -> p -> v");
axes('Parent',tab);
plot(t, in, "LineWidth", 2);
hold on;
plot(t, out_v, "LineWidth", 2, 'Color','#EDB120');
plot(t, res_vpv, "--", "LineWidth", 2, 'Color','#7E2F8E');
axis([0, t_max, -amplitude-0.2, amplitude+0.2])
xticks(0:5:t_max);
yticks(-amplitude-0.2:0.2:amplitude+0.2)
xlabel('Time (second)');
ylabel('Velocity (m/s)');
grid on;
model_txt = sprintf("Model (Fit: %.2f %%)", fit_vpv);
legend("CMD", "Real", model_txt, 'FontName', 'Times New Roman', ...
    'FontSize', 16, 'Location', 'north', 'Orientation', 'horizontal', 'NumColumns', 3);
title(txt)
set(gca, 'FontName','Times New Roman', 'FontSize',16);
% v_cmd -> p -> v
tab = uitab(tg,'title', "v_cmd -> v");
axes('Parent',tab);
plot(t, in, "LineWidth", 2);
hold on;
plot(t, out_v, "LineWidth", 2, 'Color','#EDB120');
plot(t, res_vv, "--", "LineWidth", 2, 'Color','#7E2F8E');
axis([0, t_max, -amplitude-0.2, amplitude+0.2])
xticks(0:5:t_max);
yticks(-amplitude-0.2:0.2:amplitude+0.2)
xlabel('Time (second)');
ylabel('Velocity (m/s)');
grid on;
model_txt = sprintf("Model (Fit: %.2f %%)", fit_vv);
legend("CMD", "Real", model_txt, 'FontName', 'Times New Roman', ...
    'FontSize', 16, 'Location', 'north', 'Orientation', 'horizontal', 'NumColumns', 3);
title(txt)
set(gca, 'FontName','Times New Roman', 'FontSize',16);


%% save identify data
if save_switch
    % structure
    ex.t = t;
    ex.in = in;
    ex.out_v = out_v;
    ex.out_p = out_p;
    ex.in_v_int = res_int;
    vp = struct_data(tf_vp, fit_vp, res_vp);
    vpv = struct_data(tf_vpv, fit_vpv, res_vpv);
    vv = struct_data(tf_vv, fit_vv, res_vv);
    % save
    save_dir = sprintf("./identify/%s/%.2f-%.2f-%.2f-%.0f-0.7/identify_res.mat", date, amplitude, f0, f1, sweeptime);
    save(save_dir, "ex", "vv", "vp", "vpv");
end
end


%% structure function
function res = struct_data(tf_data, fit_data, res_data)
res.tf = tf(tf_data);
res.fit = fit_data;
res.res = res_data;
end