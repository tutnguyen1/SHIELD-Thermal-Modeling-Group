function [] = Tyler4(win, Tgen, X_Log)

% X-Y Line Plot Graph 1 % -------------------------------------------------
% GRAPH SETUP %
% graphing window to use
fig = figure(win); clf(win); % figure graphic information
ax = axes(); % axis graphic information
pl = plot(ax, Tgen,X_Log);
lgn = legend();

% Graph Labels %
fig.Name = "Concentration vs. Generator Operating Temperature"; % name of figure
ax.XLabel.String = 'Temperature [deg. C]'; % x label
ax.YLabel.String = 'Concentration [% LiBr by kg]'; % y label
lgn.String = ["Strong","Weak"];

% Formatting Settings %
pl(1).LineWidth = 2;
pl(2).LineWidth = 2;
ax.Title.String = fig.Name;
ax.FontSize = 14;
ax.Title.FontSize = 18;
ax.XLabel.FontSize = 18;
ax.YLabel.FontSize = 18;

% Axis Settings:
% xline(ax, 78);
% yline(ax, 0);
ax.XLim = [78 max(Tgen)];
ax.YLim = [0.5 0.75];
end 