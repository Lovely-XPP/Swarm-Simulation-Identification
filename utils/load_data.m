function data = load_data(amplitude, f0, f1, sweeptime, h)
filename = sprintf("./identify/%.2f-%.2f-%.2f-%.0f-%.1f/identify_data.mat", amplitude, f0, f1, sweeptime, h);
data = load(filename);
end

