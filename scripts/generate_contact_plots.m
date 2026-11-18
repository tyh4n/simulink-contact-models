%% Generate figures and CSV files from the logging blocks in the examples.
repoRoot = fileparts(fileparts(mfilename('fullpath')));
addpath(repoRoot)
cd(repoRoot)
modelFolder = fullfile(repoRoot, 'examples');
docsFolder = fullfile(repoRoot, 'docs');

%% Square sliding contact versus rolling cylinder.
run(fullfile(repoRoot, 'rolling_params.m'))
model = 'rolling_contact_test';
load_system(fullfile(modelFolder, [model '.slx']))
set_param(model, 'SimMechanicsOpenEditorOnUpdate', 'off')
out = sim(model, 'StopTime', '5', ...
    'SimulationMode', 'normal', 'ReturnWorkspaceOutputs', 'on');

squareFy = out.get('log_square_Fy');
squareFx = out.get('log_square_Fx');
rollingFy = out.get('log_rolling_Fy');
rollingFx = out.get('log_rolling_Fx');
t = squareFy.Time;

writetable(table(t, squareFy.Data, squareFx.Data, ...
    rollingFy.Data, rollingFx.Data, ...
    'VariableNames', {'time_s', 'square_Fy_N', 'square_Fx_N', ...
    'rolling_Fy_N', 'rolling_Fx_N'}), ...
    fullfile(docsFolder, 'contact_force_comparison.csv'))

fig = figure('Visible', 'off', 'Color', 'w', ...
    'Position', [100 100 1100 720]);
layout = tiledlayout(2, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
title(layout, 'Square sliding contact vs rolling cylinder')
layout.Title.Color = 'k';
layout.Title.FontSize = 14;

nexttile
plot(t, squareFx.Data, '-', 'LineWidth', 1.5)
hold on
plot(t, rollingFx.Data, '--', 'LineWidth', 1.5)
grid on
xlabel('Time [s]')
ylabel('Longitudinal friction F_x [N]')
legend('Square slide', 'Rolling cylinder', 'Location', 'best')
title('Friction force')

nexttile
plot(t, squareFy.Data, '-', 'LineWidth', 1.5)
hold on
plot(t, rollingFy.Data, '--', 'LineWidth', 1.5)
grid on
xlabel('Time [s]')
ylabel('Normal force F_y [N]')
legend('Square slide', 'Rolling cylinder', 'Location', 'best')
title('Normal force')

styleFigure(fig)
exportgraphics(fig, ...
    fullfile(docsFolder, 'contact_force_comparison.png'), ...
    'Resolution', 180)
close(fig)
close_system(model, 0)

%% 36-point sliding cylinder versus rolling cylinder.
run(fullfile(repoRoot, 'rolling_params_36.m'))
model = 'rolling_contact_36_example';
load_system(fullfile(modelFolder, [model '.slx']))
set_param(model, 'SimMechanicsOpenEditorOnUpdate', 'off')
out = sim(model, 'StopTime', '2', ...
    'SimulationMode', 'normal', 'ReturnWorkspaceOutputs', 'on');

slidingFy = out.get('log_36_Fy_CoM');
slidingFx = out.get('log_36_Fx_CoM');
rollingFy = out.get('log_rolling_Fy');
rollingFx = out.get('log_rolling_Fx');
t = slidingFy.Time;

writetable(table(t, slidingFy.Data, slidingFx.Data, ...
    rollingFy.Data, rollingFx.Data, ...
    'VariableNames', {'time_s', 'sliding36_Fy_N', 'sliding36_Fx_N', ...
    'rolling_Fy_N', 'rolling_Fx_N'}), ...
    fullfile(docsFolder, 'cylinder_comparison.csv'))

fig = figure('Visible', 'off', 'Color', 'w', ...
    'Position', [100 100 1100 720]);
layout = tiledlayout(2, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
title(layout, '36-contact sliding cylinder vs rolling cylinder')
layout.Title.Color = 'k';
layout.Title.FontSize = 14;

nexttile
plot(t, slidingFx.Data, '-', 'LineWidth', 1.5)
hold on
plot(t, rollingFx.Data, '--', 'LineWidth', 1.5)
grid on
xlabel('Time [s]')
ylabel('Longitudinal friction F_x [N]')
legend('36-contact sliding cylinder', 'Rolling cylinder', ...
    'Location', 'best')
title('Friction force at CoM')

nexttile
plot(t, slidingFy.Data, '-', 'LineWidth', 1.5)
hold on
plot(t, rollingFy.Data, '--', 'LineWidth', 1.5)
grid on
xlabel('Time [s]')
ylabel('Normal force F_y [N]')
legend('36-contact sliding cylinder', 'Rolling cylinder', ...
    'Location', 'best')
title('Normal force at CoM')

styleFigure(fig)
exportgraphics(fig, ...
    fullfile(docsFolder, 'cylinder_comparison.png'), ...
    'Resolution', 180)
close(fig)
close_system(model, 0)

function styleFigure(fig)
axesHandles = findall(fig, 'Type', 'axes');
set(axesHandles, 'Color', 'w', 'XColor', 'k', 'YColor', 'k', ...
    'GridColor', [0.75 0.75 0.75], 'FontName', 'Helvetica');
for ax = axesHandles'
    ax.Title.Color = 'k';
    ax.XLabel.Color = 'k';
    ax.YLabel.Color = 'k';
end
end
