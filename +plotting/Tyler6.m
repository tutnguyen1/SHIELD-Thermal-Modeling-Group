function [] = Tyler6(win, time, Q, area_ratio)

% X-Y Line Plot Graph 1 % -------------------------------------------------
Q = Q / 1000; % Convert Q to MW

% GRAPH SETUP %
% graphing window to use
fig = figure(win); clf(win); % figure graphic information
ax = axes(); % axis graphic information
pl = plot(ax, time, Q);
lgn = legend();

% Graph Labels %
fig.Name = "Heats vs Time (50% heat recovery)"; % name of figure
ax.XLabel.String = 'Time [hr]'; % x label
ax.YLabel.String = 'Power [MW]'; % y label
% legend_percentages = "PV Solar Area Ratio " + string(area_ratio .* 100) + "%";
% lgn.String = ["Data Center", legend_percentages'];
lgn.String = ["Data Center", "Solar PV", "Absorber", "Condenser", "Pump"];

% Formatting Settings %
for i = 1:max(size(pl,1))
    pl(i).LineWidth = 2;
end 
ax.Title.String = fig.Name;
ax.FontSize = 14;
ax.Title.FontSize = 18;
ax.XLabel.FontSize = 18;
ax.YLabel.FontSize = 18;

% Axis Settings:
% xline(ax, 78);
% yline(ax, 0);
ax.XLim = [0 24];
ax.XTick = [0:4:24];
ax.YLim = [0 .0005];
end 