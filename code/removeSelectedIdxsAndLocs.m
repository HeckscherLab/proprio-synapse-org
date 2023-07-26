function data = removeSelectedIdxsAndLocs(data, idxsToRemove)
% Process data.lookup, data.idxs (all fields), and data.locs.

  data.lookup    = data.lookup(~idxsToRemove, :);
  data.locs.pre  = data.locs.pre(~idxsToRemove, :);
  data.locs.post = data.locs.post(~idxsToRemove, :);
    % iterate through all fields in idxs:
  data.idxs.pre  = structfun(@(x) x(~idxsToRemove), data.idxs.pre, 'UniformOutput', false);
  data.idxs.post = structfun(@(x) x(~idxsToRemove), data.idxs.post, 'UniformOutput', false);