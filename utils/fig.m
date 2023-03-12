function fig(out, amplitude, f0, f1, h)
time = 80;
if f0 == 0.09 && f1 == 1.21
    time = 120;
end
%% Load Data
data = out;
t = data.tout;
p = data.state;
v = data.vel;
v_cmd = data.v_cmd;
p_cmd = data.p_cmd;
cf_v = data.cf_v;
cf_p = data.cf_p;
cf_pv = data.cf_pv;
v = v(t>=20, :);
p = p(t>=20, :);
v_cmd = v_cmd(t>=20, :);
p_cmd = p_cmd(t>=20, :);
cf_v = cf_v(t>=20, :);
cf_p = cf_p(t>=20, :);
cf_pv = cf_pv(t>=20, :);
t = t(t>=20);
t = t - t(1);
% save("data.mat", "v_cmd", "v", "p", '-mat');

mode = 1;
set(0,'defaultfigurecolor','w');
img = figure('Name','SineSweep','Units','centimeters', 'Position',[1 5 28 14]);
if mode == 0
    plot(t, v_cmd(:,1), "LineWidth", 2);
    hold on;
    plot(t, v(:,1), "LineWidth", 2);
    plot(t, cf_v(:,1), '--', "LineWidth", 2);
    plot(t, cf_pv(:,1), '--', "LineWidth", 2);
    axis([0, max(t), min(v(:,1))*1.2, max(v(:,1))*1.2])
    xlabel('Time (second)');
    ylabel('Velocity (m/s)');
    grid on;
    legend("Cmd", "Response", "Model 1", "Model 2",'FontName','Times New Roman', 'FontSize', 16, 'Location', 'northwest');
    set(gca, 'FontName','Times New Roman', 'FontSize',16);
end
if mode == 1
    tg = uitabgroup;
    % X Velocity
    tab = uitab(tg,'title', "X Velocity");
    axes('Parent',tab);
    plot(t, v_cmd(:,1), "LineWidth", 2);
    hold on;
    plot(t, v(:,1), "LineWidth", 2);
    axis([0, max(t), min(v(:,1))*1.2, max(v(:,1))*1.2])
    xlabel('Time (second)');
    ylabel('Velocity (m/s)');
    grid on;
    legend("Cmd", "Response", 'FontName', 'Times New Roman', 'FontSize', 16, 'Location', 'southwest');
    set(gca, 'FontName','Times New Roman', 'FontSize',16);
    % Y Velocity
    tab = uitab(tg,'title', "Y Velocity");
    axes('Parent',tab);
    plot(t, v_cmd(:,2), "LineWidth", 2);
    hold on;
    plot(t, v(:,2), "LineWidth", 2);
    axis([0, max(t), min(v(:,2))*1.2, max(v(:,2))*1.2])
    xlabel('Time (second)');
    ylabel('Velocity (m/s)');
    grid on;
    legend("Cmd", "Response", 'FontName', 'Times New Roman', 'FontSize', 16, 'Location', 'northwest');
    set(gca, 'FontName','Times New Roman', 'FontSize',16);
    % H Velocity
    tab = uitab(tg,'title', "H Velocity");
    axes('Parent',tab);
    plot(t, v_cmd(:,3), "LineWidth", 2);
    hold on;
    plot(t, v(:,3), "LineWidth", 2);
    axis([0, max(t), min(v(:,3))*1.2, max(v(:,3))*1.2])
    xlabel('Time (second)');
    ylabel('Velocity (m/s)');
    grid on;
    legend("Cmd", "Response", 'FontName','Times New Roman', 'FontSize', 16, 'Location', 'northwest');
    set(gca, 'FontName','Times New Roman', 'FontSize',16);
    % X Position
    tab = uitab(tg,'title', "X Position");
    axes('Parent',tab);
    plot(t, p(:,1), 'LineWidth', 2);
    xlabel('Time (second)');
    ylabel('Position (m)');
    grid on;
    axis([0, max(t), -inf, inf])
    set(gca, 'FontName','Times New Roman', 'FontSize',16);
    % Y Position
    tab = uitab(tg,'title', "Y Position");
    axes('Parent',tab);
    plot(t, p_cmd(:,2), "LineWidth", 2);
    hold on;
    plot(t, p(:,2), 'LineWidth', 2);
    axis([0, max(t), -inf, inf])
    xlabel('Time (second)');
    ylabel('Position (m)');
    legend("Cmd", "Response", 'FontName','Times New Roman', 'FontSize', 16, 'Location', 'northwest');
    grid on;
    set(gca, 'FontName','Times New Roman', 'FontSize',16);
    % Z Position
    tab = uitab(tg,'title', "Height");
    axes('Parent',tab);
    plot(t, p_cmd(:,3), "LineWidth", 2);
    hold on;
    plot(t, p(:,3), 'LineWidth', 2);
    axis([0, max(t), -inf, inf])
    xlabel('Time (second)');
    ylabel('Height (m)');
    legend("Cmd", "Response", 'FontName','Times New Roman', 'FontSize', 16, 'Location', 'northwest');
    grid on;
    set(gca, 'FontName','Times New Roman', 'FontSize',16);
    % Angles
    tab = uitab(tg,'title', "Angles");
    axes('Parent',tab);
    plot(t, p(:,4)*180/pi, "LineWidth", 2);
    hold on;
    plot(t, p(:,5)*180/pi, "LineWidth", 2);
    plot(t, p(:,6)*180/pi, "LineWidth", 2);
    xlabel('Time (second)');
    ylabel('Angle (degree)');
    legend("Pitch", "Roll", "Yaw", 'FontName','Times New Roman', 'FontSize', 16, 'Location', 'northwest');
    grid on;
    set(gca, 'FontName','Times New Roman', 'FontSize',16);
end

%% save data
savedir = sprintf("./identify/%.2f-%.2f-%.2f-%.0f-%.1f", amplitude, f0, f1, time, h);
if ~exist(savedir, "dir")
    mkdir(savedir);
end
in = v_cmd(:,1);
out_p = p(:,1) - p(1,1);
out_v = v(:,1);
save(strcat(savedir, "/identify_data.mat"), "t", "out_p", "out_v", "in", '-mat');
end