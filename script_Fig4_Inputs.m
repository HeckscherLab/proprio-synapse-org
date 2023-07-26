% Figures 4, 5, 6:
% Locations and counts of proprioceptor, chordotonal, md cIV INPUT synapses.
% code for all of Figure 4, as well as 5E, 5F and 6E, 6F.

projDir = 'proprio-synapse-org';

proInFile  = fullfile(projDir, 'data/pro_synapses_in_T3-A2.mat');
choInFile  = fullfile(projDir, 'data/cho_synapses_in.mat');
mdsInFile  = fullfile(projDir, 'data/mdIV_synapses_in.mat');

proOutFile = fullfile(projDir, 'data/pro_synapses_out_T3-A2.mat');
choOutFile = fullfile(projDir, 'data/cho_synapses_out.mat');
mdsOutFile = fullfile(projDir, 'data/mdIV_synapses_out.mat');

% Define names we will search for throughout:
    proNames = {'dbd' 'ddaD' 'ddaE' 'dmd1' 'vpda' 'vbd'};
    proOrder = {'dbd' 'vbd' 'ddaD' 'ddaE' 'vpda' 'dmd1'};  % different order for plotting
    choNames = {'lch5_1' 'lch5_2_4' 'lch5_3' 'lch5_5' 'vch' 'v_ch'}; 
    choNamesTranslation = {'lch5-1' 'lch5-2/4' 'lch5-3' 'lch5-5' 'vch' 'v''ch'}; 
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

  cMap = lines(7);

% Set default axes limits based on (slightly adjusted) pro T3-A2 plot:
  lims = [21600 81600
          93000 157370
          60000 90200];


%%  Proprio: input synapses over all synapses, T3-A2, by type

  points = [proIn.locs.post; proOut.locs.pre];
    idxs = proIn.idxs.post;
  groups = [idxs.dbd, idxs.ddaD, idxs.ddaE, idxs.dmd1, idxs.vpda, idxs.vbd];
  groups = [groups; false(size(proOut.locs.pre, 1), size(groups, 2))];

  labels = {'output' proNames{:}};
    synapse3dVizLargePoints(points, groups, labels, cMap, 0.2, 0.9, lims);
      title('inputs onto proprioceptors')


%%  Chordotonal: input synapses over all synapses, T3-A2, by type

  points = [choIn.locs.post; choOut.locs.pre];
    idxs = choIn.idxs.post;
  groups = [idxs.lch5_1, idxs.lch5_2_4, idxs.lch5_3, idxs.lch5_5, idxs.vch, idxs.v_ch];
  groups = [groups; false(size(choOut.locs.pre, 1), size(groups, 2))];

  labels = {'output' choNamesTranslation{:}};
    synapse3dVizLargePoints(points, groups, labels, cMap, 0.1, 0.9, lims);
      title('inputs onto chordotonals')


%%  md IVs: input synapses over all synapses, T3-A2, by type

  points = [mdsIn.locs.post; mdsOut.locs.pre];
    idxs = mdsIn.idxs.post;
  groups = [idxs.ddaC, idxs.vdaB, idxs.v_ada];
  groups = [groups; false(size(mdsOut.locs.pre, 1), size(groups, 2))];

  labels = {'output' mdsNamesTranslation{:}};
    synapse3dVizLargePoints(points, groups, labels, cMap, 0.1, 0.9, lims);
      title('inputs onto md IVs')



%%  proprio: input vs. output counts

segt = 'A1';
labels = {'dbd L' 'dbd R' 'vbd L' 'vbd R' 'ddaD L' 'ddaD R' 'ddaE L' 'ddaE R' 'vpda L' 'vpda R' 'dmd1 L' 'dmd1 R'}; 

    proCounts = nan(2*length(proNames), 2);   % First col: inputs. Second col: outputs.
for i = 1:length(proNames)
    sn = proOrder{i};
    proCounts(i*2-1, 1) = sum(proIn.idxs.post.(sn) & proIn.idxs.post.(segt) & proIn.idxs.post.L);
    proCounts(i*2, 1)   = sum(proIn.idxs.post.(sn) & proIn.idxs.post.(segt) & proIn.idxs.post.R);
    % account for duplicate entries per output node (from multiple post nodes):
      outIdxsL = proOut.idxs.pre.(sn) & proOut.idxs.pre.(segt) & proOut.idxs.pre.L;
      outIdxsR = proOut.idxs.pre.(sn) & proOut.idxs.pre.(segt) & proOut.idxs.pre.R;
    proCounts(i*2-1, 2) = length(unique(proOut.lookup.preNode(outIdxsL)));
    proCounts(i*2, 2)   = length(unique(proOut.lookup.preNode(outIdxsR)));
end

figure, bar(proCounts, 'grouped');
  legend({'inputs' 'outputs'})
  title(sprintf('input vs. output node counts, %s', segt))
  ylabel('# nodes')
    set(gca, 'box', 'off', 'tickdir', 'out')
    ax = gca;
    ax.XTick = 1:length(proCounts); ax.XTickLabel = labels;  ax.TickLabelInterpreter = 'none';


%% Input to output ratio - Bar plots

segt = 'A1';
labels = {'dbd L' 'dbd R' 'vbd L' 'vbd R' 'ddaD L' 'ddaD R' 'ddaE L' 'ddaE R' 'vpda L' 'vpda R' 'dmd1 L' 'dmd1 R' ...
    'lch5-1 L' 'lch5-1 R' 'lch5-2/4 L' 'lch5-2/4 R' 'lch5-3 L' 'lch5-3 R' 'lch5-5 L' 'lch5-5 R' ...
    'v''ch L' 'v''ch R' 'vch L' 'vch R' 'ddaC L' 'ddaC R' 'v''ada L' 'v''ada R' 'vdaB L' 'vdaB R'};

    proCounts = nan(2*length(proNames), 2);   % First col: inputs. Second col: outputs.
    nameOrder = {'dbd' 'vbd' 'ddaD' 'ddaE' 'vpda' 'dmd1'};  % different from regular plotting order...
for i = 1:length(proNames)
    sn = nameOrder{i};
    proCounts(i*2-1, 1) = sum(proIn.idxs.post.(sn) & proIn.idxs.post.(segt) & proIn.idxs.post.L);
    proCounts(i*2, 1)   = sum(proIn.idxs.post.(sn) & proIn.idxs.post.(segt) & proIn.idxs.post.R);
    % account for duplicate entries per output node (from multiple post nodes):
      outIdxsL = proOut.idxs.pre.(sn) & proOut.idxs.pre.(segt) & proOut.idxs.pre.L;
      outIdxsR = proOut.idxs.pre.(sn) & proOut.idxs.pre.(segt) & proOut.idxs.pre.R;
    proCounts(i*2-1, 2) = length(unique(proOut.lookup.preNode(outIdxsL)));
    proCounts(i*2, 2)   = length(unique(proOut.lookup.preNode(outIdxsR)));
end
    choCounts = nan(2*length(choNames), 2);   % First col: inputs. Second col: outputs.
    nameOrder = {'lch5_1' 'lch5_2_4' 'lch5_3' 'lch5_5' 'v_ch' 'vch'}; 
for i = 1:length(choNames)
    sn = nameOrder{i};
    choCounts(i*2-1, 1) = sum(choIn.idxs.post.(sn) & choIn.idxs.post.(segt) & choIn.idxs.post.L);
    choCounts(i*2, 1)   = sum(choIn.idxs.post.(sn) & choIn.idxs.post.(segt) & choIn.idxs.post.R);
    % account for duplicate entries per output node:
      outIdxsL = choOut.idxs.pre.(sn) & choOut.idxs.pre.(segt) & choOut.idxs.pre.L;
      outIdxsR = choOut.idxs.pre.(sn) & choOut.idxs.pre.(segt) & choOut.idxs.pre.R;
    choCounts(i*2-1, 2) = length(unique(choOut.lookup.preNode(outIdxsL)));
    choCounts(i*2, 2)   = length(unique(choOut.lookup.preNode(outIdxsR)));
end
    mdsCounts = nan(2*length(mdsNames), 2);
    nameOrder = {'ddaC' 'v_ada' 'vdaB'};
for i = 1:length(mdsNames)
    sn = nameOrder{i};
    mdsCounts(i*2-1, 1) = sum(mdsIn.idxs.post.(sn) & mdsIn.idxs.post.(segt) & mdsIn.idxs.post.L);
    mdsCounts(i*2, 1)   = sum(mdsIn.idxs.post.(sn) & mdsIn.idxs.post.(segt) & mdsIn.idxs.post.R);
    % account for duplicate entries per output node:
      outIdxsL = mdsOut.idxs.pre.(sn) & mdsOut.idxs.pre.(segt) & mdsOut.idxs.pre.L;
      outIdxsR = mdsOut.idxs.pre.(sn) & mdsOut.idxs.pre.(segt) & mdsOut.idxs.pre.R;
    mdsCounts(i*2-1, 2) = length(unique(mdsOut.lookup.preNode(outIdxsL)));
    mdsCounts(i*2, 2)   = length(unique(mdsOut.lookup.preNode(outIdxsR)));
end    

figure, bar([proCounts; choCounts; mdsCounts], 'grouped');
  legend({'inputs' 'outputs'})
  title(sprintf('SN input vs. output node counts, %s', segt))
  ylabel('# nodes')
    set(gca, 'box', 'off', 'tickdir', 'out')
    ax = gca;
    ax.XTick = 1:length([proCounts; choCounts; mdsCounts]); ax.XTickLabel = labels;  ax.TickLabelInterpreter = 'none';

    %% total number of outputs from the three segments, each class?
% pro:
outIdxs = proOut.idxs.pre.T3 | proOut.idxs.pre.A1 | proOut.idxs.pre.A2;
proCountTotal = length(unique(proOut.lookup.preNode(outIdxs)));

% cho:
outIdxs = choOut.idxs.pre.T3 | choOut.idxs.pre.A1 | choOut.idxs.pre.A2;
choCountTotal = length(unique(choOut.lookup.preNode(outIdxs)));

% md IV:
outIdxs = mdsOut.idxs.pre.T3 | mdsOut.idxs.pre.A1 | mdsOut.idxs.pre.A2;
mdsCountTotal = length(unique(mdsOut.lookup.preNode(outIdxs)));


%% What proportion of inputs are from other sensory neurons? (pro vs cho vs mdIV)

% For proprioceptors:
  idxs = proIn.idxs.post;
  proprio = idxs.dbd | idxs.ddaD | idxs.ddaE | idxs.dmd1 | idxs.vpda | idxs.vbd;
inputsList = proIn.lookup.preName(proprio, :);

inputNamesPro = inputsList;
uniqueInputsPro = unique(inputNamesPro);
[SNInNamesPro, SNInIdxsPro] = findSNsFromNames(inputsList);
uniqueSNNamesPro = unique(SNInNamesPro);  % compare these to the other input names... do they look right?
    SNInRatioPro = sum(SNInIdxsPro) / length(SNInIdxsPro);
        otherPro = findProNames(inputsList);

% For chordotonals:
  idxs = choIn.idxs.post;
  chord = idxs.lch5_1 | idxs.lch5_2_4 | idxs.lch5_3 | idxs.lch5_5 | idxs.vch | idxs.v_ch;
inputsList = choIn.lookup.preName(chord, :);

[SNInNamesCho, SNInIdxsCho] = findSNsFromNames(inputsList);
    SNInRatioCho = sum(SNInIdxsCho) / length(SNInIdxsCho);
    % the only one input is another chordotonal.
        otherCho = SNInIdxsCho;

% For md IVs:
  idxs = mdsIn.idxs.post;
  mdIVs = idxs.ddaC | idxs.v_ada | idxs.vdaB;
inputsList = mdsIn.lookup.preName(mdIVs, :);

[SNInNamesMds, SNInIdxsMds] = findSNsFromNames(inputsList);
    SNInRatioMds = sum(SNInIdxsMds) / length(SNInIdxsMds);
        otherMds = findMdsNames(inputsList);


        % Stacked bar plots:
inputs = [sum(otherPro), sum(SNInIdxsPro &~ otherPro), sum(~SNInIdxsPro); ...
          sum(otherCho), sum(SNInIdxsCho &~ otherCho), sum(~SNInIdxsCho); ...
          sum(otherMds), sum(SNInIdxsMds &~ otherMds), sum(~SNInIdxsMds)];

figure, bar(inputs, 'stacked')
  legend({'SN, same mode' 'SN, different mode' 'other input'})
  set(gca, 'xticklabel', {'proprio', 'chordo', 'md IV'})


%%  What proportion of each neuron's inputs are from other sensory neurons?
  % proprio neurons (combine sides & segts):
idxs = proIn.idxs.post;
  inputCounts = zeros(length(proNames), 2);  % 1st col: sensory neuron; 2nd col: all other inputs
  inputNames = cell(size(inputCounts,1), 1);  % hold names

  for s = 1:length(proNames)
      sn = proOrder{s};
      snIdxs = idxs.(sn);
      inputsList = proIn.lookup.preName(snIdxs);
        % Which of these inputs are other sensory neurons?
    [SNInNames, ~] = findSNsFromNames(inputsList);
      inputCounts(s, 1) = length(SNInNames);
      inputCounts(s, 2) = length(inputsList) - length(SNInNames);
      inputNames{s} = inputsList;
  end

figure, bar(inputCounts, 'stacked')
  set(gca, 'box', 'off', 'tickdir', 'out', 'xticklabel', proOrder)
  legend({'SN input' 'other input'}, 'location', 'bestoutside')

% How many inputs/input neurons?
sum(inputCounts, 'all')
length(unique(cat(1, inputNames{:})))



%% proprio neurons -- what is the highest single ratio of inputs to outputs across T3, A1, A2?
%   and what is the average ratio?
  idxsIn  = proIn.idxs.post;
  idxsOut = proOut.idxs.pre;
    proCounts = nan(length(proNames)*2*3, 2);   % First col: inputs. Second col: outputs.
    counter = 1;
for i = 1:length(proNames)
    sn = proOrder{i};
    for segt = ["T3" "A1" "A2"]
        for side = ["L" "R"]
      inIdxs = idxsIn.(sn) & idxsIn.(segt) & idxsIn.(side);
    proCounts(counter, 1) = sum(inIdxs);
      outIdxs = idxsOut.(sn) & idxsOut.(segt) & idxsOut.(side);
      % account for duplicate entries per output node (from multiple post nodes):
    proCounts(counter, 2) = length(unique(proOut.lookup.preNode(outIdxs)));
        counter = counter + 1;
        end
    end
end
% get rid of empty T3 vbd rows:
proCounts(sum(proCounts, 2) == 0, :) = [];

ratios = proCounts(:, 1) ./ proCounts(:, 2);
max(ratios)
mean(ratios)


%%  TABLE: all output and input counts for each neuron, T3-A2

proLabels = {};
    proCounts = nan(2*length(proNames)*3, 2);   % First col: inputs. Second col: outputs.
    nameOrder = proOrder;
    counter = 1;
for segt = ["T3" "A1" "A2"]
for i = 1:length(proNames)
    sn = nameOrder{i};
    n_labels = {strcat(sn , '_', segt, "L"); strcat(sn, '_', segt, "R")};
    proLabels = cat(1, proLabels, n_labels);
    proCounts(counter, 1)    = sum(proIn.idxs.post.(sn) & proIn.idxs.post.(segt) & proIn.idxs.post.L);
    proCounts(counter+1, 1)  = sum(proIn.idxs.post.(sn) & proIn.idxs.post.(segt) & proIn.idxs.post.R);
    % account for duplicate entries per output node (from multiple post nodes):
      outIdxsL = proOut.idxs.pre.(sn) & proOut.idxs.pre.(segt) & proOut.idxs.pre.L;
      outIdxsR = proOut.idxs.pre.(sn) & proOut.idxs.pre.(segt) & proOut.idxs.pre.R;
    proCounts(counter, 2)    = length(unique(proOut.lookup.preNode(outIdxsL)));
    proCounts(counter+1, 2)  = length(unique(proOut.lookup.preNode(outIdxsR)));
      counter = counter + 2;
end
end

choLabels = {};
    choCounts = nan(2*length(choNames)*3, 2);   % First col: inputs. Second col: outputs.
    nameOrder = {'lch5_1' 'lch5_2_4' 'lch5_3' 'lch5_5' 'v_ch' 'vch'};
      realNames = {'lch5-1' 'lch5-2/4' 'lch5-3' 'lch5-5' 'v''ch' 'vchA/B'}; 
    counter = 1;
for segt = ["T3" "A1" "A2"]
for i = 1:length(choNames)
    sn = nameOrder{i};  name = realNames{i};
    n_labels = {strcat(name, '_', segt, "L"); strcat(name, '_', segt, "R")};
    choLabels = cat(1, choLabels, n_labels);
    choCounts(counter, 1) = sum(choIn.idxs.post.(sn) & choIn.idxs.post.(segt) & choIn.idxs.post.L);
    choCounts(counter+1, 1)   = sum(choIn.idxs.post.(sn) & choIn.idxs.post.(segt) & choIn.idxs.post.R);
    % account for duplicate entries per output node:
      outIdxsL = choOut.idxs.pre.(sn) & choOut.idxs.pre.(segt) & choOut.idxs.pre.L;
      outIdxsR = choOut.idxs.pre.(sn) & choOut.idxs.pre.(segt) & choOut.idxs.pre.R;
    choCounts(counter, 2) = length(unique(choOut.lookup.preNode(outIdxsL)));
    choCounts(counter+1, 2)   = length(unique(choOut.lookup.preNode(outIdxsR)));
      counter = counter + 2;
end
end

mdsLabels = {};
    mdsCounts = nan(2*length(mdsNames)*3, 2);
    nameOrder = {'ddaC' 'v_ada' 'vdaB'};
      realNames = {'ddaC' 'v''ada' 'vdaB'};
    counter = 1;
for segt = ["T3" "A1" "A2"]
for i = 1:length(mdsNames)
    sn = nameOrder{i};  name = realNames{i};
    n_labels = {strcat(name, '_', segt, "L"); strcat(name, '_', segt, "R")};
    mdsLabels = cat(1, mdsLabels, n_labels);
    mdsCounts(counter, 1) = sum(mdsIn.idxs.post.(sn) & mdsIn.idxs.post.(segt) & mdsIn.idxs.post.L);
    mdsCounts(counter+1, 1)   = sum(mdsIn.idxs.post.(sn) & mdsIn.idxs.post.(segt) & mdsIn.idxs.post.R);
    % account for duplicate entries per output node:
      outIdxsL = mdsOut.idxs.pre.(sn) & mdsOut.idxs.pre.(segt) & mdsOut.idxs.pre.L;
      outIdxsR = mdsOut.idxs.pre.(sn) & mdsOut.idxs.pre.(segt) & mdsOut.idxs.pre.R;
    mdsCounts(counter, 2) = length(unique(mdsOut.lookup.preNode(outIdxsL)));
    mdsCounts(counter+1, 2)   = length(unique(mdsOut.lookup.preNode(outIdxsR)));
      counter = counter + 2;
end   
end

allCounts = [proCounts; choCounts; mdsCounts];
allLabels = cat(1, proLabels, choLabels, mdsLabels);

countsTable = array2table(allCounts, 'RowNames', [allLabels{:}], 'VariableNames', ["inputs" "outputs"]);

%   savePath = '';
% writetable(countsTable, savePath, 'WriteRowNames', true, 'WriteVariableNames', true);


  

%% AUX FXNS

function [snList, snIdxs] = findSNsFromNames(names)
% Created a category for any sensory neuron type I saw among the unique
% inputs lists. NOTE: many neurons are still un-IDed (e.g., 'neuron
% 3292544') -- this will probs be a conservative estimate, possibly under.

% Look for proprioceptors:
    idxs.dbd  = startsWith(names, 'dbd');
    idxs.ddaD = startsWith(names, 'ddaD');
    idxs.ddaE = startsWith(names, 'ddaE');
    idxs.dmd1 = startsWith(names, 'dmd1');
    idxs.vpda = startsWith(names, 'vpda');
    idxs.vbd  = startsWith(names, 'vbd');

% Look for chordotonals:
excludePatt = ("?"|"or"|"ish"|"projection"|"PN"|"downstream");
    idxs.lch5_1 = startsWith(names, 'lch5-1') &~ contains(names, excludePatt);
    idxs.lch5_2_4 = startsWith(names, 'lch5-2/4') &~ contains(names, excludePatt);
    idxs.lch5_3 = startsWith(names, 'lch5-3 ') &~ contains(names, excludePatt);
    idxs.lch5_3_5 = startsWith(names, 'lch5-3/5') &~ contains(names, excludePatt);
    idxs.lch5_5 = startsWith(names, 'lch5-5') &~ contains(names, excludePatt);
    idxs.vch  = startsWith(names, 'vch') &~ contains(names, excludePatt);
    idxs.v_ch = startsWith(names, 'v''ch') &~ contains(names, excludePatt);

% Look for mds:
    idxs.ddaC = startsWith(names, 'ddaC', 'IgnoreCase', true);
    idxs.v_ada = startsWith(names, 'v''ada', "IgnoreCase", true);
    idxs.vdaB = startsWith(names, 'vdaB', "IgnoreCase", true);

% Look for es:
    idxs.les = startsWith(names, 'les');
    idxs.v_es = startsWith(names, 'v''es');
    idxs.ves = startsWith(names, 'ves');

% Look for misc:
    idxs.miscSN = contains(names, '(class I)', 'IgnoreCase',true) | ...
        contains(names, '(class 1)', 'IgnoreCase',true) | ... 
        contains(names, 'sensory');

% Combine fields to ID any SN meeting above criteria:
    snList = names;
    snIdxs = false(size(names));
    fnames = fieldnames(idxs);
  for f = 1:length(fnames)
    fn = fnames{f};
    snIdxs = snIdxs | idxs.(fn);
  end
  snList = snList(snIdxs);
end

function proIdxs = findProNames(names)
    dbd  = startsWith(names, 'dbd');
    ddaD = startsWith(names, 'ddaD');
    ddaE = startsWith(names, 'ddaE');
    dmd1 = startsWith(names, 'dmd1');
    vpda = startsWith(names, 'vpda');
    vbd  = startsWith(names, 'vbd');
    proIdxs = dbd | ddaD | ddaE | dmd1 | vpda | vbd;
end

function mdsIdxs = findMdsNames(names)
    ddaC = startsWith(names, 'ddaC', 'IgnoreCase', true);
    v_ada = startsWith(names, 'v''ada', "IgnoreCase", true);
    vdaB = startsWith(names, 'vdaB', "IgnoreCase", true);
    mdsIdxs = ddaC | v_ada | vdaB;
end