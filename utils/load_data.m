function data = load_data(amplitude, f0, f1, sweeptime)
filename = sprintf("./identify/%.2f-%.2f-%.2f-%.0f/identify_data.mat", amplitude, f0, f1, sweeptime);
data = load(filename);
end

