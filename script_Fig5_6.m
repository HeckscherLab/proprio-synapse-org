% Figures 5, 6:
% Locations of output synapses of chordotonal neurons (Fig. 5)
% and md class IV neurons (Fig. 6)
%   For INPUT synapse panels (Fig. 5E, 5F, 6E, 6F), see script_Fig4_Inputs.
%   This script also has code for Supplemental Figures 4 and 5.

projDir = 'proprio-synapse-org';

proInFile  = fullfile(projDir, 'data/pro_synapses_in_T3-A2.mat');
choInFile  = fullfile(projDir, 'data/cho_synapses_in.mat');
mdsInFile  = fullfile(projDir, 'data/mdIV_synapses_in.mat');

proOutFile = fullfile(projDir, 'data/pro_synapses_out_T3-A2.mat');
choOutFile = fullfile(projDir, 'data/cho_synapses_out.mat');
mdsOutFile = fullfile(projDir, 'data/mdIV_synapses_out.mat');

% Define names we will search for throughout:
    proNames = {'dbd' 'ddaD' 'ddaE' 'dmd1' 'vpda' 'vbd'};
    choNames = {'lch5_1' 'lch5_2_4' 'lch5_3' 'lch5_5' 'v_ch' 'vch'}; 
    choNamesTranslation = {'lch5-1' 'lch5-2/4' 'lch5-3' 'lch5-5' 'v''ch' 'vch'}; 
    mdsNames = {'ddaC' 'vdaB' 'v_ada'}; 
    mdsNamesTranslation = {'ddaC' 'vdaB' 'v''ada'}; 

% Pull and format the data:
    dataOut = load(proOutFile);
    dataIn  = load(proInFile);
  [proIn, proOut] = formatInputAndOutputData(dataIn, dataOut);
      clearvars proOutFile proInFile

    dataOut = load(choOutFile);
    dataIn  = load(choInFile);
  [choIn, choOut] = formatInputAndOutputData(dataIn, dataOut);
      clearvars choOutFile choInFile

    dataOut = load(mdsOutFile);
    dataIn  = load(mdsInFile);
  [mdsIn, mdsOut] = formatInputAndOutputData(dataIn, dataOut);
      clearvars mdsOutFile mdsInFile dataOut dataIn

% Handle various extra processing steps for cho/mds data:
  [choIn, choOut, mdsIn, mdsOut] = cleanAndFormatChosMdIVs(choIn, choOut, mdsIn, mdsOut);


% Get the set of proprio nodes to compare chos & md IVs to: no duplicates
% of a single node!
  uniqueProIdxs = getUniqueOutputNodeIdxs(proOut.lookup);
  proPoints = proOut.locs.pre(uniqueProIdxs, :);



%%  A1 output synapses by cell type, compared to proprio: chordotonals
%  Fig. 5A

A1 = choOut.idxs.pre.A1;
points = choOut.locs.pre;
groups = [A1 & choOut.idxs.pre.lch5_1, A1 & choOut.idxs.pre.lch5_2_4, A1 & choOut.idxs.pre.lch5_3, ...
          A1 & choOut.idxs.pre.lch5_5, A1 & choOut.idxs.pre.v_ch, A1 & choOut.idxs.pre.vch];
  points = points(A1, :);
  groups = groups(A1, :);

  % Let's display relative to proprio outputs...
  idxsSuppl = getUniqueOutputNodeIdxs(proOut.lookup, proOut.idxs.pre.A1);
pointsSuppl = proOut.locs.pre(idxsSuppl, :);
groupsSuppl = false(size(pointsSuppl, 1), size(groups, 2));
  points = [points; pointsSuppl];
  groups = [groups; groupsSuppl];

labels = {'pro out', choNamesTranslation{:}};
cMap = lines(6);
  synapse3dVizLargePoints(points, groups, labels, cMap, 0.4, 0.8);
    title('chordotonal outputs, A1')

    clearvars A1

%%  A1 output synapses by cell type, compared to proprio: md IVs
%  Fig. 6A

A1 = mdsOut.idxs.pre.A1;
points = mdsOut.locs.pre;
groups = [A1 & mdsOut.idxs.pre.ddaC, A1 & mdsOut.idxs.pre.vdaB, A1 & mdsOut.idxs.pre.v_ada];
  points = points(A1, :);
  groups = groups(A1, :);

  % Let's display relative to proprio outputs...
  idxsSuppl = getUniqueOutputNodeIdxs(proOut.lookup, proOut.idxs.pre.A1);
pointsSuppl = proOut.locs.pre(idxsSuppl, :);
groupsSuppl = false(size(pointsSuppl, 1), size(groups, 2));
  points = [points; pointsSuppl];
  groups = [groups; groupsSuppl];

labels = {'pro out', mdsNamesTranslation{:}};
cMap = lines(6);
  synapse3dVizLargePoints(points, groups, labels, cMap, 0.2, 0.9);
    title('md IV outputs, A1')

    clearvars A1


%%  T3-A2 neurons by segment: chordotonals
%  Fig. 5C

T3 = choOut.idxs.pre.T3;
A1 = choOut.idxs.pre.A1;
A2 = choOut.idxs.pre.A2;
points = choOut.locs.pre;

  groups = [T3, A1, A2];
  labels = {'' 'T3' 'A1' 'A2'};

cMap = [%189 222 21 ;   % yellow-green
          2   167 79 ;   % green
          44  54  143;   % blue
          11  221 221];  % cyan
cMap = cMap ./ 255;

  synapse3dVizMod(points, groups, labels, cMap, 0.2, 0.8);

    clearvars T3 A1 A2


%%  T3-A2 neurons by segment: md IVs
%  Fig. 6C

T3 = mdsOut.idxs.pre.T3;
A1 = mdsOut.idxs.pre.A1;
A2 = mdsOut.idxs.pre.A2;
points = mdsOut.locs.pre;

  groups = [T3, A1, A2];
  labels = {'' 'T3' 'A1' 'A2'};

cMap = [%189 222 21 ;   % yellow-green
          2   167 79 ;   % green
          44  54  143;   % blue
          11  221 221];  % cyan
cMap = cMap ./ 255;

  synapse3dVizMod(points, groups, labels, cMap, 0.2, 0.8);

    clearvars T3 A1 A2


%%  Single neuron plots by segment, compared to proprio outputs: chordotonals
%  Fig. 5D

T3 = choOut.idxs.pre.T3;
A1 = choOut.idxs.pre.A1;
A2 = choOut.idxs.pre.A2;

cMap = [2   167 79 ;   % green
        44  54  143;   % blue
        11  221 221];  % cyan
cMap = cMap ./ 255;

for n = 1:length(choNames)
    sn = choNames{n};
    snIdxs = choOut.idxs.pre.(sn);
    snTransl = choNamesTranslation{n};
  points = [choOut.locs.pre(snIdxs, :); proPoints];
  groups = [T3 & snIdxs, A1 & snIdxs, A2 & snIdxs];
    groups = groups(snIdxs, :);
    groups = [groups; false(size(proPoints, 1), size(groups, 2))];
  labels = {'proprio' 'T3' 'A1' 'A2'};

  synapse3dVizLargePoints(points, groups, labels, cMap, 0.1, 0.9);
    title(sprintf('%s outputs, T3-A2', snTransl))
end

    clearvars T3 A1 A2


%%  Single neuron plots by segment, compared to proprio outputs: md IVs
%  Fig. 6D

T3 = mdsOut.idxs.pre.T3;
A1 = mdsOut.idxs.pre.A1;
A2 = mdsOut.idxs.pre.A2;

cMap = [2   167 79 ;   % green
        44  54  143;   % blue
        11  221 221];  % cyan
cMap = cMap ./ 255;

for n = 1:length(mdsNames)
    sn = mdsNames{n};
    snIdxs = mdsOut.idxs.pre.(sn);
    snTransl = mdsNamesTranslation{n};
  points = [mdsOut.locs.pre(snIdxs, :); proPoints];
  groups = [T3 & snIdxs, A1 & snIdxs, A2 & snIdxs];
    groups = groups(snIdxs, :);
    groups = [groups; false(size(proPoints, 1), size(groups, 2))];
  labels = {'proprio' 'T3' 'A1' 'A2'};

  synapse3dVizLargePoints(points, groups, labels, cMap, 0.1, 0.9);
    title(sprintf('%s outputs, T3-A2', snTransl))
end

    clearvars T3 A1 A2


%%  Comparison: what percent of A1 output synapses are located axonally?
%  Figure 5B, 6B

% Counts (obtained visually) of axonal synapses:
  dbdLa  = 12;  dbdRa  = 16;
  vbdLa  = 26;  vbdRa  = 27;
  ddaDLa = 7;   ddaDRa = 1;
  ddaELa = 3;   ddaERa = 0;
  vpdaLa = 12;  vpdaRa = 17;
  dmd1La = 4;   dmd1Ra = 4;
% chos:
  lch5_1La = 0; lch5_1Ra = 1;
  lch5_2La = 1; lch5_2Ra = 2;
  lch5_3La = 0; lch5_3Ra = 0;
  lch5_5La = 0; lch5_5Ra = 1;
  v_chLa   = 0; v_chRa   = 0;
  vchLa    = 6; vchRa    = 0;
% md IVs:
  ddaCLa = 0;  ddaCRa = 2;
  v_adaLa = 0; v_adaRa = 0;
  vdaBLa = 1;  vdaBRa = 0;

axonalCounts = [dbdLa; dbdRa; vbdLa; vbdRa; ddaDLa; ddaDRa; ddaELa; ddaERa; vpdaLa; vpdaRa; dmd1La; dmd1Ra; ...
    lch5_1La; lch5_1Ra; lch5_2La; lch5_2Ra; lch5_3La; lch5_3Ra; lch5_5La; lch5_5Ra; v_chLa; v_chRa;...
    vchLa; vchRa; ddaCLa; ddaCRa; v_adaLa; v_adaRa; vdaBLa; vdaBRa];

segt = 'A1';
labels = {'dbd L' 'dbd R' 'vbd L' 'vbd R' 'ddaD L' 'ddaD R' 'ddaE L' 'ddaE R' 'vpda L' 'vpda R' 'dmd1 L' 'dmd1 R' ...
    'lch5-1 L' 'lch5-1 R' 'lch5-2/4 L' 'lch5-2/4 R' 'lch5-3 L' 'lch5-3 R' 'lch5-5 L' 'lch5-5 R' ...
    'v''ch L' 'v''ch R' 'vch L' 'vch R' 'ddaC L' 'ddaC R' 'v''ada L' 'v''ada R' 'vdaB L' 'vdaB R'};

    proCounts = nan(2*length(proNames), 1);   % Count rest of outputs.
    nameOrder = {'dbd' 'vbd' 'ddaD' 'ddaE' 'vpda' 'dmd1'};
for i = 1:length(proNames)
    sn = nameOrder{i};
    % account for duplicate entries per output node (from multiple post nodes):
      outIdxsL = proOut.idxs.pre.(sn) & proOut.idxs.pre.(segt) & proOut.idxs.pre.L;
      outIdxsR = proOut.idxs.pre.(sn) & proOut.idxs.pre.(segt) & proOut.idxs.pre.R;
    proCounts(i*2-1) = length(unique(proOut.lookup.preNode(outIdxsL)));
    proCounts(i*2)   = length(unique(proOut.lookup.preNode(outIdxsR)));
end
    choCounts = nan(2*length(choNames), 1); 
    nameOrder = {'lch5_1' 'lch5_2_4' 'lch5_3' 'lch5_5' 'v_ch' 'vch'}; 
for i = 1:length(choNames)
    sn = nameOrder{i};
    % account for duplicate entries per output node:
      outIdxsL = choOut.idxs.pre.(sn) & choOut.idxs.pre.(segt) & choOut.idxs.pre.L;
      outIdxsR = choOut.idxs.pre.(sn) & choOut.idxs.pre.(segt) & choOut.idxs.pre.R;
    choCounts(i*2-1) = length(unique(choOut.lookup.preNode(outIdxsL)));
    choCounts(i*2)   = length(unique(choOut.lookup.preNode(outIdxsR)));
end
    mdsCounts = nan(2*length(mdsNames), 1);
    nameOrder = {'ddaC' 'v_ada' 'vdaB'};
for i = 1:length(mdsNames)
    sn = nameOrder{i};
    % account for duplicate entries per output node:
      outIdxsL = mdsOut.idxs.pre.(sn) & mdsOut.idxs.pre.(segt) & mdsOut.idxs.pre.L;
      outIdxsR = mdsOut.idxs.pre.(sn) & mdsOut.idxs.pre.(segt) & mdsOut.idxs.pre.R;
    mdsCounts(i*2-1) = length(unique(mdsOut.lookup.preNode(outIdxsL)));
    mdsCounts(i*2)   = length(unique(mdsOut.lookup.preNode(outIdxsR)));
end

% assemble 2-column array. Subtract the first column (axonal outputs) from
% the second column (total outputs).
totalCounts = [axonalCounts, ([proCounts; choCounts; mdsCounts] - axonalCounts)];


figure, bar(totalCounts, 'stacked');
  legend({'axonal' 'other'})
  title(sprintf('SN axonal vs. remaining output node counts, %s', segt))
  ylabel('# nodes')
    set(gca, 'box', 'off', 'tickdir', 'out')
    ax = gca;
    ax.XTick = 1:length(axonalCounts); ax.XTickLabel = labels;  ax.TickLabelInterpreter = 'none';






    %%  T3-A2 neurons by segment, vs. proprios: chordotonals
    %  Supplemental Figure 4A

T3 = choOut.idxs.pre.T3;
A1 = choOut.idxs.pre.A1;
A2 = choOut.idxs.pre.A2;
points = [choOut.locs.pre; proOut.locs.pre];

  groups = [T3, A1, A2];
  groups = [groups; false(size(proOut.locs.pre, 1), size(groups, 2))];
  labels = {'proprio' 'T3' 'A1' 'A2'};

cMap = [%189 222 21 ;   % yellow-green
          2   167 79 ;   % green
          44  54  143;   % blue
          11  221 221];  % cyan
cMap = cMap ./ 255;

  synapse3dVizMod(points, groups, labels, cMap, 0.2, 0.8);

    clearvars T3 A1 A2


    %%  Single neuron plots by segment: chordotonals
    %  Supplemental Figure 4A

T3 = choOut.idxs.pre.T3;
A1 = choOut.idxs.pre.A1;
A2 = choOut.idxs.pre.A2;
points = [choOut.locs.pre];

cMap = [%189 222 21 ;   % yellow-green
          2   167 79 ;   % green
          44  54  143;   % blue
          11  221 221];  % blue
cMap = cMap ./ 255;

for n = 1:length(choNames)
    sn = choNames{n};
    snTransl = choNamesTranslation{n};
  groups = [T3 & choOut.idxs.pre.(sn), A1 & choOut.idxs.pre.(sn), A2 & choOut.idxs.pre.(sn)];
  labels = {'other' 'T3' 'A1' 'A2'};

  synapse3dVizMod(points, groups, labels, cMap, 0.1, 0.9);
    title(sprintf('%s outputs, T3-A2', snTransl))
end

    clearvars T3 A1 A2

    %%  T3-A2 neurons by segment, vs. proprios: md IVs
    % Supplemental Figure 5A

T3 = mdsOut.idxs.pre.T3;
A1 = mdsOut.idxs.pre.A1;
A2 = mdsOut.idxs.pre.A2;
points = [mdsOut.locs.pre; proOut.locs.pre];

  groups = [T3, A1, A2];
  groups = [groups; false(size(proOut.locs.pre, 1), size(groups, 2))];
  labels = {'proprio' 'T3' 'A1' 'A2'};

cMap = [2   167 79 ;   % green
        44  54  143;   % blue
        11  221 221];  % cyan
cMap = cMap ./ 255;

  synapse3dVizMod(points, groups, labels, cMap, 0.2, 0.8);

    clearvars T3 A1 A2

    %%  Single neuron plots by segment: md IVs
    %  Supplemental Figure 5A

T3 = mdsOut.idxs.pre.T3;
A1 = mdsOut.idxs.pre.A1;
A2 = mdsOut.idxs.pre.A2;
points = mdsOut.locs.pre;

cMap = [2   167 79 ;   % green
        44  54  143;   % blue
        11  221 221];  % cyan
cMap = cMap ./ 255;

for n = 1:length(mdsNames)
    sn = mdsNames{n};
    snIdxs = mdsOut.idxs.pre.(sn);
    snTransl = mdsNamesTranslation{n};
  groups = [T3 & snIdxs, A1 & snIdxs, A2 & snIdxs];
  labels = {'other' 'T3' 'A1' 'A2'};

  synapse3dVizLargePoints(points, groups, labels, cMap, 0.2, 0.8);
    title(sprintf('%s outputs, T3-A2', snTransl))
end

    clearvars T3 A1 A2


%% Overlap in synapse histograms by segment? -- chordotonals
%  The one we care about = along "Z" axis
%  Supplemental Figure 4B

%   Get the binning & axis information:
data = choOut;

points = data.locs.pre;
  T3 = data.idxs.pre.T3;
  A1 = data.idxs.pre.A1;
  A2 = data.idxs.pre.A2;
groups = false(size(points, 1), 1);
    fAx = synapse3dVizLegend(points, groups, {''}, 'highlightIdxs', 0.2, 0.8);

  xLims = xlim(fAx);  zLims = ylim(fAx);  yLims = zlim(fAx);  % Y and Z were swapped to 3D plot

  close(fAx.Parent)

binning = 1000; % 1 um (1000 nm)

cMap = [2   167 79 ;   % green
        44  54  143;   % blue
        11  221 221];  % cyan
cMap = cMap ./ 255;


    %  Single cho at a time:
for s = 1:length(choNames)
    sn = choNames{s};
  points = data.locs.pre;
  groups = [T3 & data.idxs.pre.(sn), A1 & data.idxs.pre.(sn), A2 & data.idxs.pre.(sn)];
    points = points(any(groups, 2), :);  % get rid of any other chos/points
    groups = groups(any(groups, 2), :);
  labels = {'' sprintf('T3 %s', sn) 'A1' 'A2'};

  synapseHistograms3dGroups(points, groups, labels, cMap, binning, xLims, yLims, zLims, 'probability')
end


%% Overlap in synapse histograms by segment? -- md IVs
%  The one we care about = along "Z" axis
%  Supplemental Figure 5B

%   Get the binning & axis information:
data = mdsOut;

points = data.locs.pre;
  T3 = data.idxs.pre.T3;
  A1 = data.idxs.pre.A1;
  A2 = data.idxs.pre.A2;
groups = false(size(points, 1), 1);
    fAx = synapse3dVizLegend(points, groups, {''}, 'highlightIdxs', 0.2, 0.8);

  xLims = xlim(fAx);  zLims = ylim(fAx);  yLims = zlim(fAx);  % Y and Z were swapped to 3D plot

  close(fAx.Parent)

binning = 1000; % 1 um (1000 nm)

cMap = [2   167 79 ;   % green
        44  54  143;   % blue
        11  221 221];  % cyan
cMap = cMap ./ 255;


    %  Single md IV at a time:
for s = 1:length(mdsNames)
    sn = mdsNames{s};
  points = data.locs.pre;
  groups = [T3 & data.idxs.pre.(sn), A1 & data.idxs.pre.(sn), A2 & data.idxs.pre.(sn)];
    points = points(any(groups, 2), :);  % get rid of any other mds/points
    groups = groups(any(groups, 2), :);
  labels = {'' sprintf('T3 %s', sn) 'A1' 'A2'};

  synapseHistograms3dGroups(points, groups, labels, cMap, binning, xLims, yLims, zLims, 'probability')
end




%% AUX FXNS

% GOAL: get just the unique output nodes (one entry per node, not the
% duplicates corresponding to all the downstream partners):
function uniqueIdxs = getUniqueOutputNodeIdxs(lookup, idxs)
% we will further subset the idxs sent in, if any were sent in.
  if ~exist("idxs", 'var')
      idxs = true(size(lookup, 1), 1);
  end
    uniqueNodes = unique(lookup.preNode(idxs));
    uniqueIdxs = false(size(lookup, 1), 1);
    for n = 1:length(uniqueNodes)
        % pull just the first time this node shows up:
        uniqueIdxs(find(ismember(lookup.preNode, uniqueNodes(n)), 1, 'first')) = true;
    end
end
