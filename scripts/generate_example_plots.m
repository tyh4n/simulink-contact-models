%% Generate example contact-force traces from the bundled Simulink model.
repoRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(repoRoot)
cd(repoRoot)
rolling_params

model = 'rolling_contact_test';
if bdIsLoaded(model)
    close_system(model, 0)
end
load_system(fullfile(repoRoot, 'examples', [model '.slx']))
set_param(model, 'SimMechanicsOpenEditorOnUpdate', 'off')

rolling = [model '/Rolling Contact Model'];
forceBlock = [rolling '/Slip Resistance Model'];
logBlocks = {
    [rolling '/Example Fy'], 'example_Fy', 1
    [rolling '/Example Fx'], 'example_Fx', 2
    };

for k = 1:size(logBlocks, 1)
    block = logBlocks{k, 1};
    add_block('simulink/Sinks/To Workspace', block, ...
        'VariableName', logBlocks{k, 2}, ...
        'SaveFormat', 'Timeseries', ...
        'Position', [1320 100 + 70*k 1420 120 + 70*k]);
    src = get_param(forceBlock, 'PortHandles');
    dst = get_param(block, 'PortHandles');
    add_line(rolling, src.Outport(logBlocks{k, 3}), ...
        dst.Inport(1), 'autorouting', 'on');
end

out = sim(model, 'StopTime', '12', ...
    'SimulationMode', 'normal', ...
    'ReturnWorkspaceOutputs', 'on');

normalSeries = out.get('example_Fy');
frictionSeries = out.get('example_Fx');
t = normalSeries.Time;
Fy = normalSeries.Data;
Fx = frictionSeries.Data;

dataFile = fullfile(repoRoot, 'docs', 'example_contact_forces.csv');
writetable(table(t, Fy, Fx), dataFile)

fig = figure('Visible', 'off', 'Color', 'w', ...
    'Position', [100 100 1000 650]);
tiledlayout(2, 1, 'Padding', 'compact', 'TileSpacing', 'compact')

nexttile
plot(t, Fx, 'LineWidth', 1.8)
grid on
xlabel('Time [s]')
ylabel('Longitudinal force F_x [N]')
title('Example friction force')

nexttile
plot(t, Fy, 'LineWidth', 1.8)
grid on
xlabel('Time [s]')
ylabel('Normal force F_y [N]')
title('Example normal contact force')

plotFile = fullfile(repoRoot, 'docs', 'example_contact_forces.png');
axesHandles = findall(fig, 'Type', 'axes');
set(axesHandles, 'Color', 'w', 'XColor', 'k', 'YColor', 'k', ...
    'GridColor', [0.75 0.75 0.75], 'FontName', 'Helvetica');
for ax = axesHandles'
    ax.Title.Color = 'k';
    ax.XLabel.Color = 'k';
    ax.YLabel.Color = 'k';
end
exportgraphics(fig, plotFile, 'Resolution', 180)
close(fig)

close_system(model, 0)
fprintf('Wrote %s\n', dataFile)
fprintf('Wrote %s\n', plotFile)
