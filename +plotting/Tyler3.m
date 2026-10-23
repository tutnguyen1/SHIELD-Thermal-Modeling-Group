function [] = Tyler3(win, Tgen, m_Log)

% X-Y Line Plot Graph 1 % -------------------------------------------------
% GRAPH SETUP %
% graphing window to use
fig = figure(win); clf(win); % figure graphic information
ax = axes(); % axis graphic information
pl = plot(ax, Tgen,m_Log);
lgn = legend();

% Graph Labels %
fig.Name = "Flowrates vs. Generator Operating Temperature"; % name of figure
ax.XLabel.String = 'Temperature [deg. C]'; % x label
ax.YLabel.String = 'Flow Rates [kg/s]'; % y label
lgn.String = ["Refrigerant", "Strong", "Weak"];

% Formatting Settings %
pl(1).LineWidth = 2;
pl(2).LineWidth = 2;
pl(3).LineWidth = 2;
ax.Title.String = fig.Name;
ax.FontSize = 14;
ax.Title.FontSize = 18;
ax.XLabel.FontSize = 18;
ax.YLabel.FontSize = 18;

% Axis Settings:
% xline(ax, 78);
% yline(ax, 0);
ax.XLim = [78 max(Tgen)];
ax.YLim = [0 20];

end 