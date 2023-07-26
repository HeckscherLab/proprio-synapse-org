% Figure 2: 
% Looking for locations of synapses by A-P location (segment);
% looking for somatotopy: DV somatotopy or by class (bd, da class I, dmd1)
%   -- This script also contains code for Supplemental Figure 3.

    % Add the location of the proprioceptor synapse output node data:
projDir = 'proprio-synapse-org';
dataFile = fullfile(projDir, 'data/pro_synapses_out_T3-A2.mat');

    data = load(dataFile);

    % Optional: extra data can be added below. Save from CATMAID using the
    % example python script.
dataFile = fullfile(projDir, 'data/ddaD_vbd_out-A3.mat');
    dataSuppl = load(dataFile);
    
    data = addSupplData(data, dataSuppl);

      clearvars dataFile

    data = pull_JSON_data(data, projDir);
      % add more info to the data struct from .jsons.
      % the JSON is the source of info about what neurons = MNs, PMNs.


  [~, pre, ~] = formatSNPreAndPostData(data);

    proNames  = {'dbd' 'ddaD' 'ddaE' 'dmd1' 'vpda' 'vbd'};

    % Grab default axes for plotting all A1 proprio output nodes:
    A1 = pre.idxs.A1;
    points = pre.locs(A1, :);
    fig = figure; fAx = axes(fig);
    scatter3(fAx, points(:,1), points(:,3), points(:,2));  % plot 'Z' and 'Y' out of order for expected viz
  xLims = xlim(fAx);  yLims = ylim(fAx);  zLims = zlim(fAx);
    close(fig)

  defaultA1Lims = [xLims; yLims; zLims];
    clearvars fig fAx xLims yLims zLims


%% T3-A3, color each neuron's synapses by segment.

T3 = pre.idxs.T3;
A1 = pre.idxs.A1;
A2 = pre.idxs.A2;
A3 = pre.idxs.A3;
points = pre.locs;

cMap = [%189 222 21 ;   % yellow-green
          2   167 79 ;   % green
          44  54  143;   % blue
          11  221 221    % cyan
          220 150 225];    % lilac
cMap = cMap ./ 255;

for p = 1:length(proNames)
    pn = proNames{p};
  groups = [T3 & pre.idxs.(pn), A1 & pre.idxs.(pn), A2 & pre.idxs.(pn), A3 & pre.idxs.(pn)];
  labels = {'other' 'T3' 'A1' 'A2' 'A3'};

  synapse3dVizLargePoints(points, groups, labels, cMap, 0.2, 0.8);
    title(sprintf('%s outputs, T3-A3', pn))
end

    clearvars T3 A1 A2 A3


%%  A1 neurons only. Color synapses by DV group.

A1 = pre.idxs.A1;
points = pre.locs(A1, :);
L = pre.idxs.L;

  dorsal  = pre.idxs.ddaD | pre.idxs.ddaE;
  middle  = pre.idxs.dmd1 | pre.idxs.dbd;
  ventral = pre.idxs.vpda | pre.idxs.vbd;
%   groups = [A1 & dorsal & L, A1 & middle & L, A1 & ventral & L];
  groups = [A1 & dorsal, A1 & middle, A1 & ventral];
    groups = groups(A1, :);
  labels = {'' 'dorsal' 'middle' 'ventral'};

cMapDV = [0   174 239;   % print cyan
          247 146 29 ;   % print orange
          255 0   144];  % print magenta
cMapDV = cMapDV ./ 255;
cMap = [1 0 0  % red
        0 1 1  % cyan
        0 0 1]; % blue

  synapse3dVizMod(points, groups, labels, cMap, 0.2, 0.8, defaultA1Lims);

    clearvars dorsal middle ventral cMapDV



%%  A1 neurons only, color by class.

A1 = pre.idxs.A1;
points = pre.locs(A1, :);

  bds  = pre.idxs.dbd | pre.idxs.vbd;
  das  = pre.idxs.ddaD | pre.idxs.ddaE | pre.idxs.vpda;
  dmd1 = pre.idxs.dmd1;
  groups = [A1 & bds, A1 & das, A1 & dmd1];
    groups = groups(A1, :);
  labels = {'' 'bds' 'das' 'dmd1'};

% cMap = [0.25 0.25 0.25
%         0.8 0.8 0.8
%         0.5 0.5 0.5];

cMap = [0.50 0.50 0.50     % 0.25 is indistinguishable in greyscale from the lines purple...
        0.80 0.80 0.80
        0.4940    0.1840    0.5560];   % lines (4th)

  synapse3dVizLargePoints(points, groups, labels, cMap, 0.2, 0.8, defaultA1Lims);

    clearvars bds das dmd1


%%  A1 only, md-da class Is only.

A1 = pre.idxs.A1;
points = pre.locs;

  ddaD = pre.idxs.ddaD;
  ddaE = pre.idxs.ddaE;
  vpda = pre.idxs.vpda;
  groups = [A1 & ddaD, A1 & ddaE, A1 & vpda];
    points = points(any(groups, 2), :);  % get rid of any empty rows
    groups = groups(any(groups, 2), :);   

  labels = {'' 'ddaD' 'ddaE' 'vpda'};
%   cMap = [0.8 0.8 0.8    % lightest
%           0.5 0.5 0.5
%           0.25 0.25 0.25];  % darkest
  cMap = [0.8500 0.3250 0.0980   % lines 2nd, orange
          0.9290 0.6940 0.1250   % lines 3rd, yellow
          0.4660 0.6740 0.1880]; % lines 5th, green

  synapse3dVizLargePoints(points, groups, labels, cMap, 0.2, 0.8, defaultA1Lims);

    clearvars ddaD ddaE vpda


%%  A1 only, bds only.

A1 = pre.idxs.A1;
points = pre.locs;

  dbd = pre.idxs.dbd;
  vbd = pre.idxs.vbd;
  groups = [A1 & dbd, A1 & vbd];
    points = points(any(groups, 2), :);  % get rid of any empty rows
    groups = groups(any(groups, 2), :);   

  labels = {'' 'dbd' 'vbd'};
%   cMap = [0.8 0.8 0.8    % lightest
%           0.25 0.25 0.25];  % darkest
  cMap = [0 0.4470 0.7410         % lines 1st, blue
          0.3010 0.7450 0.9330];  % lines 6th, light blue

  synapse3dVizLargePoints(points, groups, labels, cMap, 0.2, 0.8, defaultA1Lims);

    clearvars dbd vbd


%%  A1 only, dbd only.

A1 = pre.idxs.A1;
points = pre.locs;

  dbd = pre.idxs.dbd;
  groups = A1 & dbd;
    points = points(any(groups, 2), :);  % get rid of any empty rows
    groups = groups(any(groups, 2), :);   

  labels = {'' 'dbd' 'vbd'};
  cMap = lines(1);

  synapse3dVizLargePoints(points, groups, labels, cMap, 0.2, 0.8, defaultA1Lims);

    clearvars dbd


%%  T3-A2, just one class at a time (e.g., dbd)

points = pre.locs;
%   bds  = pre.idxs.dbd | pre.idxs.vbd;
%   das  = pre.idxs.ddaD | pre.idxs.ddaE | pre.idxs.vpda;
%   dmd1 = pre.idxs.dmd1;
  groups = [pre.idxs.dbd];
  labels = {'other' 'dbd'};
%   groups = das;
%   labels = {'other' 'da neurons'};

cMap = lines(7);

  synapse3dVizMod(points, groups, labels, cMap, 0.2, 0.8);

  

%%  A-P overlap in synapse histograms by segment (Along "Z" axis)
%  Supplemental Figure 3

%   Get the binning & axis information:
points = pre.locs;
  T3 = pre.idxs.T3;
  A1 = pre.idxs.A1;
  A2 = pre.idxs.A2;
  A3 = pre.idxs.A3;
groups = false(size(points, 1), 1);
    fAx = synapse3dVizLegend(points, groups, {''}, 'highlightIdxs', 0.2, 0.8);

  xLims = xlim(fAx);  zLims = ylim(fAx);  yLims = zlim(fAx);  % Y and Z were swapped to 3D plot

  close(fAx.Parent)

binning = 1000; % 1 um (1000 nm)

cMap = [2   167 79    % green
        44  54  143   % blue
        11  221 221   % cyan
        220 150 225]; % lilac
cMap = cMap ./ 255;


%  Plot all proprios combined (including A3):

% points = pre.locs;
%   groups = [T3, A1, A2, A3];
%     points = points(any(groups, 2), :);  % get rid of any unassigned points
%     groups = groups(any(groups, 2), :);
%   labels = {'', 'T3', 'A1', 'A2', 'A3'};
%     synapseHistograms3dGroups(points, groups, labels, cMap, binning, xLims, yLims, zLims, 'probability')


%  Single proprioceptor at a time (including A3):

for p = 1:length(proNames)
    pn = proNames{p};
    points = pre.locs;
  groups = [T3 & pre.idxs.(pn), A1 & pre.idxs.(pn), A2 & pre.idxs.(pn), A3 & pre.idxs.(pn)];
    points = points(any(groups, 2), :);  % get rid of any empty rows
    groups = groups(any(groups, 2), :);   
  labels = {'' sprintf('T3 %s', pn) 'A1' 'A2' 'A3'};

  synapseHistograms3dGroups(points, groups, labels, cMap, binning, xLims, yLims, zLims, 'probability')
end

