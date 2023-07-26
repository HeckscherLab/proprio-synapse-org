function synapseHistograms3d(points, binning, xLims, yLims, zLims, histMethod)
% NOTE: I have been plotting Y from the 3rd column of points, Z = 2nd col.
% I have also been reversing the axis direction so that smaller values of X
% = to the right, etc.  (See synapse3dVizLegend & offshoot fxns.)
%   This means SEND IN the limits from the "z" axis as yLims, vice versa.

if ~exist('histMethod', 'var')
    histMethod = "probability";
end

limXround = [floor(xLims(1)/binning)*binning, ceil(xLims(2)/binning)*binning];
limYround = [floor(yLims(1)/binning)*binning, ceil(yLims(2)/binning)*binning];
limZround = [floor(zLims(1)/binning)*binning, ceil(zLims(2)/binning)*binning];

xBins = limXround(1) : binning : limXround(2);
yBins = limYround(1) : binning : limYround(2);
zBins = limZround(1) : binning : limZround(2);

axProps = {'box', 'off', 'tickdir', 'out', 'xdir', 'reverse'};

figure
    axX = subplot(3, 1, 1);   
  histogram(axX, points(:, 1), xBins, 'Normalization', histMethod)
      set(axX, axProps{:}, 'xlim', limXround);
      xlabel("X, um"),  ylabel("counts")
      axX.XAxis.TickLabels = compose('%g', axX.XAxis.TickValues/1000);  % /1000: from nm to um
    axY = subplot(3, 1, 2);
  histogram(axY, points(:, 2), yBins, 'Normalization', histMethod)
      set(axY, axProps{:}, 'xlim', limYround);
      xlabel("Y, um"),  ylabel("counts")
      axY.XAxis.TickLabels = compose('%g', axY.XAxis.TickValues/1000);
    axZ = subplot(3, 1, 3);
  histogram(axZ, points(:, 3), zBins, 'Normalization', histMethod)
      set(axZ, axProps{:}, 'xlim', limZround);
      xlabel("Z, um"),  ylabel("counts")
      axZ.XAxis.TickLabels = compose('%g', axZ.XAxis.TickValues/1000);