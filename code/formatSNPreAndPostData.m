function [data, pre, post] = formatSNPreAndPostData(data)
% For use with data tables pulled from CATMAID using my pymaid scripts that
% searched for (pre) neurons' DOWNSTREAM (post) partners, i.e., connectors=
%  pymaid.get_connectors(n_ID, relation_type='presynaptic_to').connector_id

%  Pull out just the unique presynaptic node information:
    [uniquePreNodes, uFirsts, ~] = unique([data.pre_locs{:, 1}], 'stable');
  pre.nodes = uniquePreNodes';
  pre.names = data.pre_names(uFirsts)';
  pre.locs  = cell2mat(data.pre_locs(uFirsts, 2:end));
      clearvars uFirsts uniquePreNodes

% Retrieve indices for each proprio neuron, segment, and L/R side:
% (Subset of full dataset)
    nameList = pre.names';
  pre.idxs = extractSensorSegtAndSideIdxs(nameList');

% Retrieve indices for each downstream PMN and MN, segment, and L/R side:
% (Subset of full dataset)
  post = getPostDataSubset(data);
  post.idxs = extractMNandPMNIdxs(post.names, post.skIDs, post.PMNs, post.MNs);

% Get a lookup table for every connection (pre-post node pair) in the
% dataset, and match this:
    allNodes = cat(2, data.pre_locs(:, 1), data.post_locs(:, 1));
    allSkIDs = cat(2, data.cell_IDs(:, 1),data.cell_IDs(:, 2));
    allNames = cat(2, [data.pre_names]', [data.post_names]');
    nodesSkIDsNamesLookup = cat(2, allNodes, allSkIDs, allNames);
    nodesSkIDsNamesLookup = cell2table(nodesSkIDsNamesLookup, 'VariableNames', ...
        {'preNode' 'postNode' 'preSkID' 'postSkID' 'preName' 'postName'});
    fullPreIdxs  = extractSensorSegtAndSideIdxs([data.pre_names]');
      % post idxs should already be at full length (= # of connections)
    assert(length(post.idxs.MN) == length(fullPreIdxs.dbd))

% Reformat 'data' struct:
  data.lookup = nodesSkIDsNamesLookup;
  data.idxs.pre  = fullPreIdxs;
  data.idxs.post = post.idxs;
    % make variable naming more consistent:
  data.locs.pre  = cell2mat(data.pre_locs(:, 2:4));
  data.locs.post = cell2mat(data.post_locs(:, 2:4));
    % remove redundant variables:
  data = rmfield(data, ["cell_IDs", "pre_locs", "post_locs", "pre_names", "post_names", "post_MNs", "post_PMNs"]);
end


%% AUX FXNS

function postData = getPostDataSubset(data)
%  Pull out ALL (not unique) postsynaptic node information:
    postData.nodes = [data.post_locs{:, 1}]';
    postData.names = data.post_names';
    postData.locs  = cell2mat(data.post_locs(:, 2:end));
    postData.skIDs = cell2mat(data.cell_IDs(:, 2));
    postData.PMNs  = data.post_PMNs;
    postData.MNs   = data.post_MNs;
end

function idxs = extractMNandPMNIdxs(names, skIDs, PMNs, MNs)
% For pulling known groupings of post-synaptic neurons.
% names & skIDs are of same length as idxs.
% PMNs and MNs are of any length.
    idxs.PMN = ismember(skIDs, PMNs);
    idxs.MN  = ismember(skIDs, MNs);

    idxs.T3   = contains(names, (("t"|"T")+"3"+("l"|"r"|"L"|"R")));
    idxs.A1   = contains(names, (("a"|"A")+"1"+("l"|"r"|"L"|"R")));
    idxs.A2   = contains(names, (("a"|"A")+"2"+("l"|"r"|"L"|"R")));
    idxs.A3   = contains(names, (("a"|"A")+"3"+("l"|"r"|"L"|"R")));
    
    idxs.L    = contains(names, (("t"|"T"|"a"|"A") + digitsPattern(1) + ("l"|"L")));
    idxs.R    = contains(names, (("t"|"T"|"a"|"A") + digitsPattern(1) + ("r"|"R")));
end