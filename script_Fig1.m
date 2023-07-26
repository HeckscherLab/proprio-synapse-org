% Figure 1: 
% locations and stats for individual proprioceptor types' output nodes.
% This information can be found (for cells in the paper) in /data,
% or, if you have CATMAID credentials, you can extract your own node info.
%   -- This script also contains code for Supplemental Figure 2.

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



%% Individual proprioceptors (per segt). How many output synapses?
% grouped bar plot: L, R for each cell type in A1

segt = 'A1';
nameOrder = {'dbd' 'vbd' 'ddaD' 'ddaE' 'vpda' 'dmd1'};

    outCounts = nan(length(proNames), 2);
      % split groups: L, R
for s = 1:length(proNames)
    SN = nameOrder{s};
    outCounts(s, 1) = sum(pre.idxs.(SN) & pre.idxs.(segt) & pre.idxs.L);
    outCounts(s, 2) = sum(pre.idxs.(SN) & pre.idxs.(segt) & pre.idxs.R);
end

axProps = {'box', 'off', 'tickdir', 'out', 'xticklabel', nameOrder};
figure, bar(outCounts, 'grouped')
  title(sprintf('%s proprioceptor output counts', segt))
    legend({'L' 'R'}, 'location', 'bestoutside')
    set(gca, axProps{:})


  %% Proprioceptor output counts: all segts combined
labels = {'dbd_T3' 'dbd_A1' 'dbd_A2' 'ddaD_T3' 'ddaD_A1' 'ddaD_A2' 'ddaE_T3' 'ddaE_A1' 'ddaE_A2' ...
    'dmd1_T3' 'dmd1_A1' 'dmd1_A2' 'vpda_T3' 'vpda_A1' 'vpda_A2' 'vbd_T3' 'vbd_A1' 'vbd_A2'};

  outCounts = nan(length(labels), 2);
    i = 1;  % counter
  for s = 1:length(proNames)
    SN = proNames{s};
      for segt = ["T3" "A1" "A2"]
        outCounts(i, 1) = sum(pre.idxs.(SN) & pre.idxs.(segt) & pre.idxs.L);
        outCounts(i, 2) = sum(pre.idxs.(SN) & pre.idxs.(segt) & pre.idxs.R);
        i = i+1;
      end
  end
  clearvars i p pn
  axProps = {'box', 'off', 'tickdir', 'out', 'ticklabelinterpreter', 'none', ...
      'xtick', 1:length(labels), 'xticklabel', labels};

figure, bar(outCounts, 'grouped')
  title('T3-A2 proprioceptor output counts')
    legend({'L' 'R'}, 'location', 'bestoutside')
    set(gca, axProps{:})



%% Synapse count histograms along 3x axes

% NOTE: plotting the third column of data as Y, second column as Z...
% AND plotting the axes in reverse (e.g., 20k is to the right on the X
% axis, while 80k is to the left)

% one micron binning (original units are nm)
  binning = 1000;

% for all A1:
A1 = pre.idxs.A1;
points = pre.locs(A1, :);
  groups = true(size(points, 1), 1); labels = ('proprio out');
  fAx = synapse3dVizLegend(points, groups, labels, 'highlightIdxs', 0.2, 0.8);

  % Use the figure to generate limits for the histograms
  % these are the auto-set limits for proprio outputs in A1:
xLims = xlim(fAx);  % [20k, 80k]
  %  NOTE: I plot Z data on Y, vice versa:
zLims = ylim(fAx);  % [105k, 140k]  
yLims = zlim(fAx);  % [60k, 89844]

  close(fAx.Parent)

  synapseHistograms3d(points, binning, xLims, yLims, zLims, 'count');


  %%  Comparison: A1 proprio histograms overlaid.  (L and R side separately)
  % Supplemental Figure 2

A1 = pre.idxs.A1;
s = 'L';

  side = pre.idxs.(s);
  points = pre.locs(A1 & side, :);
  groups = [A1 & pre.idxs.dbd & side, A1 & pre.idxs.ddaD & side, A1 & pre.idxs.ddaE & side, ...
          A1 & pre.idxs.dmd1 & side, A1 & pre.idxs.vpda & side, A1 & pre.idxs.vbd & side];
      groups = groups(A1 & side, :);
  labels = {'' sprintf('dbd A1%s', s) 'ddaD' 'ddaE' 'dmd1' 'vpda' 'vbd'};
  cMap = lines(7);

  synapseHistograms3dGroups(points, groups, labels, cMap, binning, xLims, yLims, zLims, 'probability')


  %%  Each A1 proprioceptor separately.

A1 = pre.idxs.A1;
cMap = lines(7);

for s = 1:length(proNames)
    SN = proNames{s};
    points = pre.locs(A1, :);
    groups = pre.idxs.A1 & pre.idxs.(SN);
      groups = groups(A1, :);
      points = points(any(groups, 2), :);
      groups = groups(any(groups, 2), :);
%     labels = {'other A1' sprintf('%s A1', SN)};
    labels = {'' sprintf('%s A1', SN)};
    color = cMap(s, :);
    synapseHistograms3dGroups(points, groups, labels, color, binning, xLims, yLims, zLims, 'probability')
end


%% Left side only: repeat the above.
% binning by one micron
  binning = 1000;

% for A1L.
A1 = pre.idxs.A1;  L = pre.idxs.L;
points = pre.locs(A1 & L, :);
  groups = true(size(points, 1), 1); labels = ('L side out');
  fAx = synapse3dVizLegend(points, groups, labels, 'highlightIdxs', 0.2, 0.8);

  % these are the auto-set limits for L side proprio outputs in A1:
xLims = xlim(fAx);  % [20k, 80k]
  %  NOTE: I plotted Z data on Y, vice versa:
zLims = ylim(fAx);  % [105k, 140k]  
yLims = zlim(fAx);  % [60k, 89844]

  close(fAx.Parent)

  synapseHistograms3d(points, binning, xLims, yLims, zLims, 'count');


  %%  Comparison: A1 proprio histograms overlaid, L side only.

points = pre.locs(A1 & L, :);
cMap = lines(7);
  groups = [A1 & L & pre.idxs.dbd, A1 & L & pre.idxs.ddaD, A1 & L & pre.idxs.ddaE, ...
          A1 & L & pre.idxs.dmd1, A1 & L & pre.idxs.vpda, A1 & L & pre.idxs.vbd];
    groups = groups(A1 & L, :);
  labels = {'' 'dbd A1L' 'ddaD' 'ddaE' 'dmd1' 'vpda' 'vbd'};  

  synapseHistograms3dGroups(points, groups, labels, cMap, binning, xLims, yLims, zLims, 'probability')

  
  %%  Each A1 proprioceptor separately, L side only.

% points = pre.locs(A1 & L, :);
cMap = lines(7);

for s = 1:length(proNames)
    SN = proNames{s};
    points = pre.locs;
    groups = pre.idxs.A1 & pre.idxs.L & pre.idxs.(SN);
      points = points(any(groups, 2), :);
      groups = groups(any(groups, 2), :);
    labels = {'' sprintf('%s A1L', SN)};
    color = cMap(s, :);
    synapseHistograms3dGroups(points, groups, labels, color, binning, xLims, yLims, zLims, 'probability')
end

