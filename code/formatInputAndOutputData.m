function [in, out] = formatInputAndOutputData(dataIn, dataOut)
% Here, we care about the IDs of all inputs and all outputs, because I may
% want to match other partners than just proprio neurons.


    % OUTPUTS
% Generate a lookup table for every connection (pre-post node pair) in the
% dataset:
    allNodes = cat(2, dataOut.pre_locs(:, 1), dataOut.post_locs(:, 1));
    allSkIDs = cat(2, dataOut.cell_IDs(:, 1), dataOut.cell_IDs(:, 2));
    allNames = cat(2, [dataOut.pre_names]', [dataOut.post_names]');
    nodesSkIDsNamesLookup = cat(2, allNodes, allSkIDs, allNames);
    nodesSkIDsNamesLookup = cell2table(nodesSkIDsNamesLookup, 'VariableNames', ...
        {'preNode' 'postNode' 'preSkID' 'postSkID' 'preName' 'postName'});

% Populate 'dataOut' struct:
  out.lookup = nodesSkIDsNamesLookup;
  out.idxs.pre  = extractSensorSegtAndSideIdxs(out.lookup.preName);
  out.idxs.post = extractSensorSegtAndSideIdxs(out.lookup.postName);
  out.locs.pre  = cell2mat(dataOut.pre_locs(:, 2:4));
  out.locs.post = cell2mat(dataOut.post_locs(:, 2:4));


    % INPUTS
% For the input synapses, we have to worry about duplicate entries:
    pre_names  = [dataIn.pre_names]';
    post_names = [dataIn.post_names]';

    pre_skIDs = cell2mat(dataIn.cell_IDs);
    post_skIDs = cell2mat(dataIn.cell_IDs);
    
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