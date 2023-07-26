% Figure 3: 
% Overlap of output synapses across segment boundaries, and from all A1
% proprioceptors.
%   -- This script contains code for Supplemental Figure 1.


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


%%  All T3 - A2 proprio outputs, colored by segment

T3 = pre.idxs.T3;
A1 = pre.idxs.A1;
A2 = pre.idxs.A2;
points = pre.locs;

cMap = [2   167 79 ;   % green
        44  54  143;   % blue
        11  221 221];    % cyan
cMap = cMap ./ 255;


  groups = [T3, A1, A2];
  labels = {'' 'T3' 'A1' 'A2'};

  synapse3dVizLargePoints(points, groups, labels, cMap, 0.2, 0.8);
    title('Proprio outputs, T3-A2')

    clearvars T3 A1 A2


%%  All A1 proprio types, colored only on L side

points = pre.locs(pre.idxs.A1, :);
  A1L = pre.idxs.A1 & pre.idxs.L;
groups = [A1L & pre.idxs.dbd, A1L & pre.idxs.ddaD, A1L & pre.idxs.ddaE, ...
          A1L & pre.idxs.dmd1, A1L & pre.idxs.vpda, A1L & pre.idxs.vbd];
  groups = groups(pre.idxs.A1, :);
labels = {'A1R' 'dbd' 'ddaD' 'ddaE' 'dmd1' 'vpda' 'vbd'};
cMap = lines(6);

    synapse3dVizLargePoints(points, groups, labels, cMap, 0.2, 0.8);
      title('A1 output nodes, L side colored')
      set(gca, 'tickdir', 'out')


      %%  Overlap in the central domain of A2:
      %  Supplemental Figure 1

points = pre.locs;
idxs = pre.idxs;

groups = [idxs.dbd & idxs.A2, idxs.ddaD & idxs.A2, idxs.ddaE & idxs.A1, idxs.dmd1 & idxs.A2, ...
          idxs.vpda & idxs.A1, idxs.ddaD & idxs.A3];

  labels = {'other' 'dbd A2' 'ddaD A2' 'ddaE A1' 'dmd1 A2' 'vpda A1' 'ddaD A3'};
%   cMap = lines(6);
  cMap = [lines(5); [220 150 225]./255];   % add lilac

  synapse3dVizLargePoints(points, groups, labels, cMap, 0.2, 0.8);

