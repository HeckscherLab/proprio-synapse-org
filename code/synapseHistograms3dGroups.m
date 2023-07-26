function synapseHistograms3dGroups(points, groups, labels, cMap, binning, xLims, yLims, zLims, histMethod)
% Options for histMethod: same as for histogram (e.g., 'count' or 'probability')
% NOTE: make sure yLims correspond to 2nd col of data (if taken from
% synapse3dViz plot, these will be the "Z" axis limits), & zLims = 3rd col.

% Mess with these viz parameters:
    faceAlpha = 0.5;
    defaultColor = [0.7 0.7 0.7];    % grey
    defaultFaceAlpha = 0.5;
    defaultEdgeAlpha = 0.5;
    % line style (e.g., '-' '--' 'none'), line width


if ~exist('histMethod', 'var')
    histMethod = "probability";
end

  % Determine binning and axes limits:
limXround = [floor(xLims(1)/binning)*binning, ceil(xLims(2)/binning)*binning];
limYround = [floor(yLims(1)/binning)*binning, ceil(yLims(2)/binning)*binning];
limZround = [floor(zLims(1)/binning)*binning, ceil(zLims(2)/binning)*binning];

xBins = limXround(1) : binning : limXround(2);
yBins = limYround(1) : binning : limYround(2);
zBins = limZround(1) : binning : limZround(2);

  % Plotting:
axPropsX = {'box', 'off', 'tickdir', 'out', 'xdir', 'reverse'};
axPropsYZ = {'box', 'off', 'tickdir', 'out', 'xdir', 'normal'};

figure
    axX = subplot(3, 1, 1); hold on  
    axY = subplot(3, 1, 2); hold on
    axZ = subplot(3, 1, 3); hold on

  % First, plot any ungrouped idxs:
  histProps = {'FaceAlpha', defaultFaceAlpha, 'EdgeAlpha', defaultEdgeAlpha};
    defaultPts = ~any(groups, 2);
    color      = defaultColor;
  histogram(axX, points(defaultPts, 1), xBins, 'Normalization', histMethod, 'FaceColor', color, histProps{:})
  histogram(axY, points(defaultPts, 2), yBins, 'Normalization', histMethod, 'FaceColor', color, histProps{:})
  histogram(axZ, points(defaultPts, 3), zBins, 'Normalization', histMethod, 'FaceColor', color, histProps{:})
     

  % Second, plot groups one by one, using cMap:
  histProps = {'FaceAlpha', faceAlpha};
    numGroups = size(groups, 2);
    for i = 1:numGroups
      idxPts = groups(:, i);
      color  = cMap(i, :);
  histogram(axX, points(idxPts, 1), xBins, 'Normalization', histMethod, 'FaceColor', color, histProps{:})
  histogram(axY, points(idxPts, 2), yBins, 'Normalization', histMethod, 'FaceColor', color, histProps{:})
  histogram(axZ, points(idxPts, 3), zBins, 'Normalization', histMethod, 'FaceColor', color, histProps{:})
    end


% Apply axes properties last:
  set(axX, axPropsX{:}, 'xlim', limXround);
    xlabel(axX, "X (L-R), um")
    ylabel(axX, histMethod)
    axX.XAxis.TickLabels = compose('%g', axX.XAxis.TickValues/1000);  % /1000: from nm to um
  set(axY, axPropsYZ{:}, 'xlim', limYround);
    xlabel(axY, "Y (D-V), um")
    ylabel(axY, histMethod)
    axY.XAxis.TickLabels = compose('%g', axY.XAxis.TickValues/1000);
  set(axZ, axPropsYZ{:}, 'xlim', limZround);
    xlabel(axZ, "Z (A-P), um")
    ylabel(axZ, histMethod)
    axZ.XAxis.TickLabels = compose('%g', axZ.XAxis.TickValues/1000);

  legend(axX, labels, 'location', 'bestoutside', 'Interpreter', 'none')
  legend(axY, labels, 'location', 'bestoutside', 'Interpreter', 'none')
  legend(axZ, labels, 'location', 'bestoutside', 'Interpreter', 'none')
