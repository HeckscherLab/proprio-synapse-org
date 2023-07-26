function figAx = synapse3dVizMod(points, groups, labels, cMap, defaultOpacity, idxOpacity, axLims)
% groups = logical with same number rows as points; each col = grouping.
%   any points that do not have any true entry will be 'default' & plotted
%   in grey.
% cMap needs to have as many rows as there are groups (cols) in neuronIDs.
% axes needs to have three rows: 2 values each, the low and high value for
% X, Y, Z axis (in that row order)

defaultPts     = ~any(groups, 2);   % any ungrouped idxs
defaultColor   = [0.7 0.7 0.7];     % make them grey points
if ~exist("defaultOpacity", "var")
  defaultOpacity = 0.2;  
end
if ~exist("idxOpacity", "var")
  idxOpacity     = 0.9;
end

  % ~~ Plotting options: ~~ %
pointSize = 36;

  % ~~ Axes/labeling options: ~~ %
xLabel = 'X';
yLabel = 'Z';
zLabel = 'Y';
    % I am flipping order of plotting Z and Y so that Y becomes the
    % 'vertical' axis by default.
    % I think all the axes need to be inverted to match...
xDir = 'reverse';  % (animal's) L shows on L side 
yDir = 'reverse';  % anterior = top, posterior = bottom
zDir = 'reverse';  % dorsal = top, ventral = bottom
  axProps = {'xdir', xDir, 'ydir', yDir, 'zdir', zDir, ...
    'tickdir', 'out', 'box', 'on'};

  % ~~ Generate plot: ~~ %
fig = figure; 
figAx = axes(fig, axProps{:});
  hold on

  % Method 'highlightIdx' from synapse3dVizLegend:
    numGroups = size(groups, 2);
  % Plot the 'default' points:
      scatter3(points(defaultPts, 1), points(defaultPts, 3), points(defaultPts, 2), pointSize, ...
               defaultColor, 'filled', 'MarkerFaceAlpha', defaultOpacity);
  % Plot the 'highlight' idx points:
    for i = 1:numGroups
      idxPts = groups(:, i);
      color  = cMap(i, :);
      scatter3(points(idxPts, 1), points(idxPts, 3), points(idxPts, 2), pointSize, ...
               color, 'filled', 'MarkerFaceAlpha', idxOpacity);
    end
    grid on
    xlabel(xLabel), ylabel(yLabel), zlabel(zLabel)
    legend(labels, "Interpreter", "none", "Location", "bestoutside")
  % If axes lims were sent in, apply them here:
    if exist("axLims", "var")
        set(figAx, 'xlim', axLims(1,:), 'ylim', axLims(2,:), 'zlim', axLims(3,:))
    end
