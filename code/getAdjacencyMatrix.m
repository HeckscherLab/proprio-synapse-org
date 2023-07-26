function [adjMatrix, colIDs, rowIDs] = getAdjacencyMatrix(lookup)
% Match preSkID to each of the postSkIDs.

    postIDs = unique(lookup.postSkID);
    preIDs  = unique(lookup.preSkID, 'stable');
%   adjMatrix = sparse(length(preIDs), length(postIDs));
  adjMatrix = zeros(length(preIDs), length(postIDs));

  for p = 1:length(preIDs)
    pre = preIDs(p);
    postPartners = categorical(lookup.postSkID(lookup.preSkID == pre), postIDs);
    adjMatrix(p, :) = countcats(postPartners);
  end
  colIDs = postIDs';
  rowIDs = preIDs;