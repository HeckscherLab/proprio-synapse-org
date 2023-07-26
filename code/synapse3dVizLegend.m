function figAx = synapse3dVizLegend(points, neuronIDs, labels, method, defaultOpacity, idxOpacity)
% method options --
%   'uniqueNeuronLR': requires there be twelve categories in neuronIDs.
%   'highlightIdxs': all points plotted grey as default, but each column of
%  neuronIDs is used as a new 'highlight' idx -- those points are given a
%  unique color (from left to right)
%   '18 neurons': if I have 18 neuron groups (6x SNs times 3x segts)

[names, ~, nameIdxs] = unique(neuronIDs, 'stable');
  % irrelevant for some coloring methods.

defaultPts     = ~any(neuronIDs, 2);  % any ungrouped idxs
defaultColor   = [0.7 0.7 0.7];       % make them grey points
if ~exist("defaultOpacity", "var")
  defaultOpacity = 0.2;  
end
if ~exist("idxOpacity", "var")
  idxOpacity     = 0.9;
end

  % ~~ Colormap options: ~~ %
    if strcmp(method, 'uniqueNeuronLR')
        cMap = generateColorsLRNeurons(names);
          % TO DO: replace my weird custom colors for L vs. R?
    elseif strcmp(method, '12 neurons')
        cMap = getCIELAB_12;
    elseif strcmp(method, '18 neurons')
        cMap = getCIELAB_18;
    elseif strcmp(method, 'highlightIdxs')
    % plots all grey as default, adds unique colors for the nodes
    % in each index
        cMap = generateColorsHighlights(neuronIDs);
    else
        cMap = turbo(length(names));
%         cMap = hsv(length(names));
%         colors = cMap(nameIdxs, :);
    end

  % ~~ Plotting options: ~~ %
pointSize = 36;
plotProps = {'filled', ...
    'MarkerFaceAlpha', 0.8 ...
    };

  % ~~ Axes/labeling options: ~~ %
xLabel = 'X';
yLabel = 'Z';
zLabel = 'Y';
    % I am flipping order of plotting Z and Y so that Y becomes the
    % 'vertical' axis by default.
xTickLabel = {};
yTickLabel = {};
zTickLabel = {};
    % I think all the axes need to be inverted to match...
xDir = 'reverse';  % (animal's) L shows on L side 
yDir = 'reverse';  % anterior = top, posterior = bottom
zDir = 'reverse';  % dorsal = top, ventral = bottom

  axProps = {'xdir', xDir, 'ydir', yDir, 'zdir', zDir, ...
    'XTickLabels', xTickLabel, 'YTickLabels', yTickLabel, 'zticklabels', zTickLabel, ...
    'box', 'on', 'tickdir', 'out'};


    % ~~ Generate plot: ~~ %
  fig = figure; 
  figAx = axes(fig, axProps{:});
  hold on

if strcmp(method, 'highlightIdxs')
    numGroups = size(neuronIDs, 2);
    % Plot the 'default' points:
      scatter3(points(defaultPts, 1), points(defaultPts, 3), points(defaultPts, 2), pointSize, ...
               defaultColor, 'filled', 'MarkerFaceAlpha', defaultOpacity);
    % Plot the 'highlight' idx points:
    for i = 1:numGroups
      idxPts = neuronIDs(:, i);
      color  = cMap(i, :);
      scatter3(points(idxPts, 1), points(idxPts, 3), points(idxPts, 2), pointSize, ...
          color, 'filled', 'MarkerFaceAlpha', idxOpacity);
    end

elseif size(neuronIDs, 2) > 1   % We have one-hot columns corresponding to idxs
    numGroups = size(neuronIDs, 2);
    % Plot any 'default' points:
      scatter3(points(defaultPts, 1), points(defaultPts, 3), points(defaultPts, 2), pointSize, ...
               defaultColor, 'filled', 'MarkerFaceAlpha', defaultOpacity);
    % Plot the points corresponding to each group using cMap:
    for i = 1:numGroups
      idxPts = neuronIDs(:, i);
      color  = cMap(i, :);
      scatter3(points(idxPts, 1), points(idxPts, 3), points(idxPts, 2), pointSize, ...
          color, 'filled', 'MarkerFaceAlpha', idxOpacity);
    end

else
    numGroups = length(names);
    for i = 1:numGroups
        gIdxs = nameIdxs==i;
        color = cMap(i, :);
        scatter3(points(gIdxs,1), points(gIdxs,3), points(gIdxs,2), pointSize, color, plotProps{:});
    end
end

%   set(gca, axProps{:})
  grid on
  xlabel(xLabel), ylabel(yLabel), zlabel(zLabel)
  legend(labels, "Interpreter", "none", "Location", "bestoutside")


%%
function cMap = generateColorsLRNeurons(names)
% names = unique neuron IDs. Currently expects them sent in this order:
    % [n1L, n1R, n2L, n2R... n6R]
% TO DO: handle different #s of groups. (make one by segment: 3x
% closely-related colors for T3 vs. A1 vs. A2)
%   = 6x groups
% TO DO: better color map!! Take one from online... CIELAB sthg-or-other?
    numNeurons = length(names);
    % Here, we'll use bolder/paler versions of the same color for the
    % L/R synapses from "same" neurons (L/R pair)
    colors = [235, 60,  50 ;  % red L
              235, 130, 120;  % red R
              235, 175, 50 ;  % yellow L
              235, 225, 160;  % yellow R
              200, 230, 50 ;  % lime L
              230, 245, 160;  % lime R
              50 , 230, 50 ;  % green L 2
              150, 230, 150;  % green R 2
              50 , 130, 220;  % cerulean L
              150, 185, 230;  % cerulean R
              130, 50 , 230;  % violet L
              185, 150, 230;  % violet R
              235, 130, 50 ;  % orange L
              235, 175, 120;  % orange R
              140, 230, 50 ;  % green L 1
              205, 245, 160;  % green R 1
              50 , 220, 200;  % aqua L
              150, 230, 220];  % aqua R
              
        cMap = colors(1:numNeurons, :);
        cMap = cMap./255;  % convert to expected scale ([0 1])
%         colors = cMap(nameIdxs, :);


function cMap = generateColorsHighlights(groupIDs)
  % Return cMap rather than colors for this version of the fxn.
  % See synapse3dViz() for alternative.
    numGroups = size(groupIDs, 2);
    if numGroups <= 8
        cMap = lines(numGroups);
    else
        cMap = turbo(numGroups);
    end

function cMap = getCIELAB_12
% % cielab.io  -- then get RGB using color picker
cMap =  [255 163 159;  % red 3
%          255 78  81 ;  % red 5
         209 22  37 ;  % red 7
         255 213 150;  % orange 3
%          255 169 76 ;
         213 107 29 ;
         255 250 151;  % yellow 3
%          252 218 58 ;  % yellow 6
         213 176 43 ;  % yellow 7
         183 234 149;  % green 3
%          113 208 75 ; 
         52  157 37 ;
         142 213 253;  % blue 3
%          53  170 251;
         0   110 213;
         211 173 244;  % purple 3
%          145 86  218;
         83  32  167];   % "v2 colors"

% cMap =   [255 156 114;  % volcano 4
%          252 84  39 ;  % volcano 6
%          175 34  11 ;  % volcano 8

% cMap =  [255 163 159;  % red 3
%          255 78  81 ;  % red 5
%          209 22  37 ;  % red 7
%          255 214 112;  % gold 4
%          252 172 48 ;  % gold 6
%          174 104 22 ;  % gold 8
%          234 254 151;  % lime 3
%          160 216 54 ;  % lime 6
%          90  140 29 ;  % lime 8
%          131 232 222;  % cyan 3
%          0   194 194;  % cyan 6
%          0   109 116;  % cyan 8
%          130 166 251;  % geekblue 4
%          39  86  230;  % geekblue 6
%          7   38  155;  % geekblue 8
%          255 133 190;  % magenta 4
%          237 49  147;  % magenta 6
%          160 19  103]; % magenta 8
%  "v1 colors"

cMap =  [255 214 112;  % gold 4
%          252 172 48 ;  % gold 6
         174 104 22 ;  % gold 8
         234 254 151;  % lime 3
%          160 216 54 ;  % lime 6
         90  140 29 ;  % lime 8
         131 232 222;  % cyan 3
%          0   194 194;  % cyan 6
         0   109 116;  % cyan 8
         130 166 251;  % geekblue 4
%          39  86  230;  % geekblue 6
         7   38  155;  % geekblue 8
         255 133 190;  % magenta 4
%          237 49  147;  % magenta 6
         160 19  103;  % magenta 8
         255 163 159;  % red 3
%          255 78  81 ;  % red 5
         209 22  37 ]; % red 7
%  "v3 colors"
cMap = cMap ./ 255;

function cMap = getCIELAB_18
% cielab.io  -- then get RGB using color picker
% cMap =  [255 163 159;  % red 3
%          255 78  81 ;  % red 5
%          209 22  37 ;  % red 7
%          255 213 150;  % orange 3
%          255 169 76 ;
%          213 107 29 ;
%          255 250 151;  % yellow 3
%          252 218 58 ;  % yellow 6
%          213 176 43 ;  % yellow 7
%          183 234 149;  % green 3
%          113 208 75 ; 
%          52  157 37 ;
%          142 213 253;  % blue 3
%          53  170 251;
%          0   110 213;
%          211 173 244;  % purple 3
%          145 86  218;
%          83  32  167];   % "v2 colors"

% cMap =   [255 156 114;  % volcano 4
%          252 84  39 ;  % volcano 6
%          175 34  11 ;  % volcano 8

% cMap =  [255 163 159;  % red 3
%          255 78  81 ;  % red 5
%          209 22  37 ;  % red 7
%          255 214 112;  % gold 4
%          252 172 48 ;  % gold 6
%          174 104 22 ;  % gold 8
%          234 254 151;  % lime 3
%          160 216 54 ;  % lime 6
%          90  140 29 ;  % lime 8
%          131 232 222;  % cyan 3
%          0   194 194;  % cyan 6
%          0   109 116;  % cyan 8
%          130 166 251;  % geekblue 4
%          39  86  230;  % geekblue 6
%          7   38  155;  % geekblue 8
%          255 133 190;  % magenta 4
%          237 49  147;  % magenta 6
%          160 19  103]; % magenta 8
%  "v1 colors"

cMap =  [255 214 112;  % gold 4
         252 172 48 ;  % gold 6
         174 104 22 ;  % gold 8
         234 254 151;  % lime 3
         160 216 54 ;  % lime 6
         90  140 29 ;  % lime 8
         131 232 222;  % cyan 3
         0   194 194;  % cyan 6
         0   109 116;  % cyan 8
         130 166 251;  % geekblue 4
         39  86  230;  % geekblue 6
         7   38  155;  % geekblue 8
         255 133 190;  % magenta 4
         237 49  147;  % magenta 6
         160 19  103;  % magenta 8
         255 163 159;  % red 3
         255 78  81 ;  % red 5
         209 22  37 ]; % red 7
%  "v3 colors"
cMap = cMap ./ 255;
