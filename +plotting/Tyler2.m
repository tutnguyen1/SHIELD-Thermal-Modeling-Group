function [] = Tyler2(win, Tgen, Qg_Log)

% X-Y Line Plot Graph 1 % -------------------------------------------------
% GRAPH SETUP %
% graphing window to use
fig = figure(win); clf(win); % figure graphic information
ax = axes(); % axis graphic information
pl = plot(ax, Tgen,Qg_Log);

% Graph Labels %
fig.Name = "Generator Heat Input vs. Operating Temperature"; % name of figure
ax.XLabel.String = 'Temperature [deg. C]'; % x label
ax.YLabel.String = 'Heat Input [kW]'; % y label

% Formatting Settings %
pl.LineWidth = 2;
ax.Title.String = fig.Name;
ax.FontSize = 14;
ax.Title.FontSize = 18;
ax.XLabel.FontSize = 18;
ax.YLabel.FontSize = 18;

% Axis Settings:
% xline(ax, 78);
yline(ax, 0);
ax.XLim = [78 max(Tgen)];
ax.YLim = [0 max(Qg_Log)];

end 