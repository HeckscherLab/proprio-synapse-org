function figAx = synapse3dVizLargePoints(points, groups, labels, cMap, defaultOpacity, idxOpacity, axLims)
% groups = logical with same number rows as points; each col = grouping.
%   any points that do not have any true entry will be 'default' & plotted
%   in grey.
% cMap needs to have as many rows as there are groups (cols) in neuronIDs.
% axes needs to have three rows: 2 values each, the low and high value for
% X, Y, Z axis (in that row order)

% Set size for points:
  pointSizeSmol = 36;
  pointSizeLorg = 60;

defaultPts     = ~any(groups, 2);  % any ungrouped idxs
defaultColor   = [0.7 0.7 0.7];       % make them grey points

%     cMap = generateColorsHighlights(neuronIDs);

  % ~~ Axes/labeling options: ~~ %
xLabel = 'X';
yLabel = 'Z';
zLabel = 'Y';
    % I am flipping order of plotting Z and Y so that Y becomes the
    % 'vertical' axis by default.
    % All the axes also need to be inverted to match my display expectation...
xDir = 'reverse';  % (animal's) L shows on L side 
yDir = 'reverse';  % anterior = top, posterior = bottom
zDir = 'reverse';  % dorsal = top, ventral = bottom

% xTickLabel = {};
% yTickLabel = {};
% zTickLabel = {};
%   axProps = {'xdir', xDir, 'ydir', yDir, 'zdir', zDir, ...
%     'XTickLabels', xTickLabel, 'YTickLabels', yTickLabel, 'zticklabels', zTickLabel, ...
%     'box', 'on', 'tickdir', 'out'};

  % I'm going to start showing the axes numbers so I can match to scalebar:
  axProps = {'xdir', xDir, 'ydir', yDir, 'zdir', zDir, ...
    'box', 'on', 'tickdir', 'out'};

    % ~~ Generate plot: ~~ %
  fig = figure; 
  figAx = axes(fig, axProps{:});
  hold on

  % Plot the 'default' points:
    scatter3(points(defaultPts, 1), points(defaultPts, 3), points(defaultPts, 2), pointSizeSmol, ...
             defaultColor, 'filled', 'MarkerFaceAlpha', defaultOpacity);

  % Plot the 'highlight' idx points:
  numGroups = size(groups, 2);
    for i = 1:numGroups
      idxPts = groups(:, i);
      color  = cMap(i, :);
      scatter3(points(idxPts, 1), points(idxPts, 3), points(idxPts, 2), pointSizeLorg, ...
               color, 'filled', 'MarkerFaceAlpha', idxOpacity);
    end

  grid on
  xlabel(xLabel), ylabel(yLabel), zlabel(zLabel)
  legend(labels, "Interpreter", "none", "Location", "bestoutside")
  % If axes were sent in, apply them here:
    if exist("axLims", "var")
        set(figAx, 'xlim', axLims(1,:), 'ylim', axLims(2,:), 'zlim', axLims(3,:))
    end
end

function cMap = generateColorsHighlights(groupIDs)
  % Return cMap rather than colors for this version of the fxn.
  % See synapse3dViz() for alternative.
    numGroups = size(groupIDs, 2);
    if numGroups <= 8
        cMap = lines(numGroups);
    else
        cMap = turbo(numGroups);
    end
end