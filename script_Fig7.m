% Figure 7: 
% looking for proprio-to-MN synapses.

projDir = 'proprio-synapse-org';
dataFile = fullfile(projDir, 'data/pro_synapses_out_T3-A2.mat');
    data = load(dataFile);
    data = pull_JSON_data(data, projDir);  % add info about MNs from JSON
    [data, ~, ~] = formatSNPreAndPostData(data);

% Redo input struct idxing to use all SN names:
  data.idxs.pre = extractProChoMdSegtAndSideIdxs(data.lookup.preName);

% Redo output struct idxing to use MN information:
  data.idxs.post = extractMNSegtSideIdxs(data.lookup.postName);

% Clean up 4x 'MN' entries that are incomplete/unpaired in our dataset.
  data = cleanUnfinishedMNs(data);


  %% Where are proprioceptor-to-MN outputs (relative to rest of A1)? (Fig. 7A)

ontoMN = data.idxs.post.MN_A1;
A1     = data.idxs.pre.A1;
dbd = data.idxs.pre.dbd;  ddaD = data.idxs.pre.ddaD;  ddaE = data.idxs.pre.ddaE;
dmd1 = data.idxs.pre.dmd1;  vpda = data.idxs.pre.vpda;  vbd = data.idxs.pre.vbd;

cMap = lines(6);

points = data.locs.pre(A1, :);
groups = [ontoMN & dbd, ontoMN & ddaD, ontoMN & ddaE, ontoMN & dmd1, ontoMN & vpda, ontoMN & vbd];
  groups = groups(A1, :);
  labels = {'other A1' 'onto A1 MNs, A1 dbd'};

  synapse3dVizLargePoints(points, groups, labels, cMap, 0.4, 0.9);


  %%  Define domains (Fig. 7B)

  % ~~ Dorsal region ~~ %
% (has synapses from dbd only)

dbdA1L = A1 & dbd & L;  dbdA1R = A1 & dbd & R;
dorsalL = dbdA1L;
  dorsalL(data.locs.pre(:, 1) < 60000 | data.locs.pre(:, 1) > 75000) = false;  % crop idxs by xlims (redundant w L)
  dorsalL(data.locs.pre(:, 3) < 115000 | data.locs.pre(:, 3) > 120000) = false;
  dorsalL(data.locs.pre(:, 2) < 69000 | data.locs.pre(:, 2) > 71000) = false;
dorsalR = dbdA1R;
  dorsalR(data.locs.pre(:, 1) < 38000 | data.locs.pre(:, 1) > 51000) = false;  % crop idxs by xlims
  dorsalR(data.locs.pre(:, 3) < 115000 | data.locs.pre(:, 3) > 120000) = false;
  dorsalR(data.locs.pre(:, 2) < 64000 | data.locs.pre(:, 2) > 67000) = false;

  % double-check the numbers:
%   length(unique(data.lookup.preNode(dorsalL)))
%   length(unique(data.lookup.preNode(dorsalR)))

  % ~~ Ventral Anterior region ~~ %
% (has synapses from ddaD, ddaE, and dmd1 only)

vaA1L = (A1 & ddaD & L) | (A1 & ddaE & L) | (A1 & dmd1 & L);  
vaA1R = (A1 & ddaD & R) | (A1 & ddaE & R) | (A1 & dmd1 & R);

  vaA1L(data.locs.pre(:, 1) < 70000 | data.locs.pre(:, 1) > 78000) = false;  % crop idxs by xlims (redundant w L)
  vaA1L(data.locs.pre(:, 3) < 118000 | data.locs.pre(:, 3) > 122000) = false; % I plot 3rd col on Y axis
  vaA1L(data.locs.pre(:, 2) < 83000 | data.locs.pre(:, 2) > 88000) = false;

  vaA1R(data.locs.pre(:, 1) < 39000 | data.locs.pre(:, 1) > 47000) = false;  % crop idxs by xlims
  vaA1R(data.locs.pre(:, 3) < 120000 | data.locs.pre(:, 3) > 122000) = false;
  vaA1R(data.locs.pre(:, 2) < 82000 | data.locs.pre(:, 2) > 85000) = false;

    % ~~ Ventral Posterior region ~~ %
% (has synapses from vpda and vbd only)

vpA1L = (A1 & vpda & L) | (A1 & vbd & L);  
vpA1R = (A1 & vpda & R) | (A1 & vbd & R);

  vpA1L(data.locs.pre(:, 1) < 65000 | data.locs.pre(:, 1) > 80000) = false;  % crop idxs by xlims (redundant w L)
  vpA1L(data.locs.pre(:, 3) < 122000 | data.locs.pre(:, 3) > 126000) = false; % I plot 3rd col on Y axis
  vpA1L(data.locs.pre(:, 2) < 81000 | data.locs.pre(:, 2) > 90000) = false;

  vpA1R(data.locs.pre(:, 1) < 33000 | data.locs.pre(:, 1) > 47000) = false;  % crop idxs by xlims
  vpA1R(data.locs.pre(:, 3) < 122000 | data.locs.pre(:, 3) > 128000) = false;
  vpA1R(data.locs.pre(:, 2) < 75000 | data.locs.pre(:, 2) > 88000) = false;


  %%  How many synapses from dorsal, VA, and VP domains contact motor neurons?
% Bar plot: (unique) presynapses contacting MNs, stacked under (unique)
% presynapses not contacting MNs in these domains, L vs. R sides

dorsalSynCountsL = length(unique(data.lookup.preNode(dorsalL)));
dorsalMNCountsL  = length(unique(data.lookup.preNode(dorsalL & MN)));
dorsalSynCountsR = length(unique(data.lookup.preNode(dorsalR)));
dorsalMNCountsR  = length(unique(data.lookup.preNode(dorsalR & MN)));
VASynCountsL = length(unique(data.lookup.preNode(vaA1L)));
VAMNCountsL  = length(unique(data.lookup.preNode(vaA1L & MN)));
VASynCountsR = length(unique(data.lookup.preNode(vaA1R)));
VAMNCountsR  = length(unique(data.lookup.preNode(vaA1R & MN)));
VPSynCountsL = length(unique(data.lookup.preNode(vpA1L)));
VPMNCountsL  = length(unique(data.lookup.preNode(vpA1L & MN)));
VPSynCountsR = length(unique(data.lookup.preNode(vpA1R)));
VPMNCountsR  = length(unique(data.lookup.preNode(vpA1R & MN)));

synCounts = [dorsalMNCountsL, dorsalSynCountsL - dorsalMNCountsL
             dorsalMNCountsR, dorsalSynCountsR - dorsalMNCountsR
             VAMNCountsL, VASynCountsL - VAMNCountsL
             VAMNCountsR, VASynCountsR - VAMNCountsR
             VPMNCountsL, VPSynCountsL - VPMNCountsL
             VPMNCountsR, VPSynCountsR - VPMNCountsR];

figure
bar(synCounts, 'stacked');
  set(gca, 'xtick', 1:6, 'XTickLabel', ["dorsL" "dorsR" "VA L" "VA R" "VP L" "VP R"], ...
      'tickdir', 'out', 'TickLabelInterpreter', 'none', 'box', 'off');
  legend({'outputs to MNs' 'other outputs'}, 'Location', 'bestoutside')
  title('output synapses in proximal domains')


%% Data for Fig. 7C, 7D: connectivity table, from POV of MNs

% We need to replace the data struct with one containing info about MNs'
% inputs, instead of proprio outputs:
      % ~~ Process MN data: ~~ %
dataFile  = fullfile(projDir, 'data/MN_inputs.mat');

  data = load(dataFile);
  data = formatInputData(data);
    clearvars dataFile

% For now, get rid of all other downstream neurons from these nodes, as
% well as any MNs that are not in A1:
  data = subsetToA1MNs(data);

% Redo input struct idxing to use all SN names:
  data.idxs.pre = extractProChoMdSegtAndSideIdxs(data.lookup.preName);

% Redo output struct idxing to use MN information:
  data.idxs.post = extractMNSegtSideIdxs(data.lookup.postName);

% Clean up 4x 'MN' entries that are incomplete/unpaired in our dataset.
  data = cleanUnfinishedMNs(data);


% Get adjacency matrix:
  [A, colIDs, rowIDs] = getAdjacencyMatrix(data.lookup);
  MNnameLookup = unique(data.lookup(:, [4 6]), 'rows');
    % bc getAdjacencyMatrix sorts colIDs, the order here will match col order
    MNnames = MNnameLookup(:, 2);
    MNnames = MNnames{:, 1};

    proNames  = {'dbd' 'ddaD' 'ddaE' 'dmd1' 'vpda' 'vbd'};

% Pull idxs of adjacency matrix that match to proprioceptor inputs:
  proList = unique(data.lookup.preSkID(contains(data.lookup.preName, proNames)));   % only a1 dbds atm
  proRows = ismember(rowIDs, proList);


%% Which MNs are directly innervated?

allInCounts = sum(A, 1);
proInCounts = sum(A(proRows, :), 1);

  axProps = {'box', 'off', 'tickdir', 'out', 'xtick', 1:length(proInCounts), ...
      'xticklabel', MNnames, 'ticklabelinterpreter', 'none'};
    figure, bar(proInCounts);
      ylabel('proprio input nodes')
      set(gca, axProps{:});

  % How many proprio inputs relative to other inputs?
    figure, bar([proInCounts; allInCounts-proInCounts]', 'stacked');
      ylabel('input nodes')
      legend({'proprio' 'all'})
      set(gca, axProps{:});


%%  Histogram: counts of MNs that get innervation (by # input synapses)

  allInCounts = sum(A, 1);
  proInCounts = sum(A(proRows, :), 1);

figure, histogram(proInCounts)
  set(gca, 'box', 'off', 'tickdir', 'out')
  xlabel('# input synapses from proprioceptors')
  ylabel('motor neuron count')


  %%  Numbers for the 2x MNs getting bilateral inputs...

RP2 = ismember(colIDs, [13057994, 13058240]);
MN4 = ismember(colIDs, [14047945, 14087339]);

allInCounts_RP2 = sum(A(:, RP2), 'all');
proInCounts_RP2 = sum(A(proRows, RP2), 'all');
allInCounts_MN4 = sum(A(:, MN4), 'all');
proInCounts_MN4 = sum(A(proRows, MN4), 'all');

fprintf('RP2 %% inputs from dbd: %d \n', proInCounts_RP2 / allInCounts_RP2 * 100)
fprintf('MN4 %% inputs from dbd: %d \n', proInCounts_MN4 / allInCounts_MN4 * 100)


  %%  Numbers from the perspective of dbd (A1) outputs...

dbdL = ismember(rowIDs, 13671419);
dbdR = ismember(rowIDs, 6195521);

dbdLToMNCounts = sum(A(dbdL, :), 'all')
dbdRToMNCounts = sum(A(dbdR, :), 'all')






    %% AUX FXNS

function in = formatInputData(dataIn)
% For MOTOR NEURONS.
% Here, we care about the IDs of all inputs, not about outputs.

    % INPUTS
% For the input synapses, we have to worry about duplicate entries:
    pre_names  = [dataIn.pre_names]';
    post_names = [dataIn.post_names]';

    pre_skIDs = cell2mat(dataIn.cell_IDs(:, 1));
    post_skIDs = cell2mat(dataIn.cell_IDs(:, 2));
    
    pre_nodes  = cell2mat(dataIn.pre_locs(:, 1));
    post_nodes = cell2mat(dataIn.post_locs(:, 1));

    in.locs.pre  = cell2mat(dataIn.pre_locs(:, 2:end));
    in.locs.post = cell2mat(dataIn.post_locs(:, 2:end));

% NOTE: there will be duplicate entries if the same presynaptic node
% targets more than one postsynaptic neuron. Get rid of these before
% constructing lookup/idxs:
    [~, uniqueEntries, ~] = unique([pre_nodes, post_nodes], 'rows', 'first');
    uniqueEntries = sort(uniqueEntries);

% Remove non-unique entries:
    in.locs.pre  = in.locs.pre(uniqueEntries, :);
    in.locs.post = in.locs.post(uniqueEntries, :);

% Format info about connections as a lookup table, to make indexing easier:
    allNodes = cat(2, pre_nodes(uniqueEntries), post_nodes(uniqueEntries));
    allSkIDs = cat(2, pre_skIDs(uniqueEntries), post_skIDs(uniqueEntries));
    allNames = cat(2, pre_names(uniqueEntries), post_names(uniqueEntries));
      nodesSkIDsNamesLookup = [num2cell(allNodes), num2cell(allSkIDs), allNames];
    in.lookup = cell2table(nodesSkIDsNamesLookup, 'VariableNames', ...
        {'preNode' 'postNode' 'preSkID' 'postSkID' 'preName' 'postName'});

% Extract idxs to the extent possible using names:
    in.idxs.pre  = extractSensorSegtAndSideIdxs(in.lookup.preName);
    in.idxs.post = extractSensorSegtAndSideIdxs(in.lookup.postName);
end


function data = subsetToA1MNs(data)
% Get rid of any entries in lookup (and locs) that are NOT A1 motor
% neurons.
  names = data.lookup.postName;
    MNSearchPatt = '^MN.*a1[lr]';   % regexp; name must begin with MN and be in a1.
    MNNames = regexp(names, MNSearchPatt, 'match', 'ignorecase', 'lineanchors');

    idxsToKeep = ~cellfun(@(x) isempty(x), MNNames, 'unif', true);
  data.locs.pre  = data.locs.pre(idxsToKeep, :);
  data.locs.post = data.locs.post(idxsToKeep, :);
  data.lookup    = data.lookup(idxsToKeep, :);
  data.idxs = [];  % We'll need to redo these after this fxn runs.
end


function idxs = extractProChoMdSegtAndSideIdxs(names)
% For pulling known groupings of proprio, cho, and md class IV neurons 
% based on their naming schemes in the connectome.
% Idxs for segment and side currently only look from T2 - A3.
    idxs.dbd  = contains(names, 'dbd', 'IgnoreCase', true);
    idxs.ddaD = contains(names, 'ddaD');
    idxs.ddaE = contains(names, 'ddaE');
    idxs.dmd1 = contains(names, 'dmd1');
    idxs.vpda = contains(names, 'vpda');
    idxs.vbd  = contains(names, 'vbd');
        % NOTE: none should require 'IgnoreCase'

    % For pulling known groupings of chordotonals: some have names that
    % need to be excluded.
excludePatt = ("?"|"or"|"ish"|"projection"|"PN");
    idxs.lch5_1 = contains(names, 'lch5-1') &~ contains(names, excludePatt);
    idxs.lch5_2_4 = contains(names, 'lch5-2/4') &~ contains(names, excludePatt);
    idxs.lch5_3 = contains(names, 'lch5-3 ') &~ contains(names, excludePatt);
    idxs.lch5_3_5 = contains(names, 'lch5-3/5') &~ contains(names, excludePatt);
    idxs.lch5_5 = contains(names, 'lch5-5') &~ contains(names, excludePatt);
    idxs.vch  = contains(names, 'vch') &~ contains(names, excludePatt);
    idxs.v_ch = contains(names, 'v''ch') &~ contains(names, excludePatt);
        % NOTE: none should require 'IgnoreCase'

    idxs.ddaC = contains(names, 'ddaC', 'IgnoreCase', true);
    idxs.v_ada = contains(names, 'v''ada', "IgnoreCase", true);
    idxs.vdaB = contains(names, 'vdaB', "IgnoreCase", true);
        % NOTE: some of these neurons DO require 'IgnoreCase'
    
    idxs.T2   = contains(names, ("t2"+("l"|"r")), 'IgnoreCase', true);
    idxs.T3   = contains(names, ("t3"+("l"|"r")), 'IgnoreCase', true);
    idxs.A1   = contains(names, ("a1"+("l"|"r")), 'IgnoreCase', true);
    idxs.A2   = contains(names, ("a2"+("l"|"r")), 'IgnoreCase', true);
    idxs.A3   = contains(names, ("a3"+("l"|"r")), 'IgnoreCase', true);
    
    idxs.L    = contains(names, (("t2"|"t3"|"a1"|"a2"|"a3") + "l"), 'IgnoreCase', true);
    idxs.R    = contains(names, (("t2"|"t3"|"a1"|"a2"|"a3") + "r"), 'IgnoreCase', true);
end

function idxs = extractMNSegtSideIdxs(names)
% For MOTOR NEURONS.
    MNSearchPatt = '^MN.*a1[lr]';   % regexp; name must begin with MN and be in a1.
    MNNames = regexp(names, MNSearchPatt, 'match', 'ignorecase', 'lineanchors');

    idxs.T2   = contains(names, ("t2"+("l"|"r")), 'IgnoreCase', true);
    idxs.T3   = contains(names, ("t3"+("l"|"r")), 'IgnoreCase', true);
    idxs.A1   = contains(names, ("a1"+("l"|"r")), 'IgnoreCase', true);
    idxs.A2   = contains(names, ("a2"+("l"|"r")), 'IgnoreCase', true);
    idxs.A3   = contains(names, ("a3"+("l"|"r")), 'IgnoreCase', true);
    
    idxs.L    = contains(names, (("t2"|"t3"|"a1"|"a2"|"a3") + "l"), 'IgnoreCase', true);
    idxs.R    = contains(names, (("t2"|"t3"|"a1"|"a2"|"a3") + "r"), 'IgnoreCase', true);

    idxs.MN_A1 = ~cellfun(@(x) isempty(x), MNNames, 'UniformOutput', true);
end

function data = cleanUnfinishedMNs(data)
% 3x unfinished entries; 1x unpaired entry.
  badMNsNames = {'MN ISN MN_a1l L only', 'MN ISN MN_a1l_to be completed', ...
      'MN ISN MN_a1r    R only ', 'MN SN_a1l'};
  badMNsIdxs = ismember(data.lookup.postName, badMNsNames);
  data = removeSelectedIdxsAndLocs(data, badMNsIdxs);
end
