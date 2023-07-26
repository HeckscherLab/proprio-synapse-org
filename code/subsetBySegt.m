function data = subsetBySegt(data, segts, usePre)
% match names of segts sent in to the fields of idxs
% if usePre = true:  match idxs in data.idxs.pre;
% if usePre = false: match idxs in data.idxs.post;
% Process data.lookup, data.idxs (all fields), and data.locs.

idxsToKeep = false(size(data.locs.pre, 1), 1);
if usePre
    for s = 1:length(segts)
        segName = segts(s);
        idxsToKeep(data.idxs.pre.(segName)) = true;
    end
else
    for s = 1:length(segts)
        segName = segts(s);
        idxsToKeep(data.idxs.post.(segName)) = true;
    end
end

  data.lookup    = data.lookup(idxsToKeep, :);
  data.locs.pre  = data.locs.pre(idxsToKeep, :);
  data.locs.post = data.locs.post(idxsToKeep, :);
    % iterate through all fields in idxs:
  data.idxs.pre  = structfun(@(x) x(idxsToKeep), data.idxs.pre, 'UniformOutput', false);
  data.idxs.post = structfun(@(x) x(idxsToKeep), data.idxs.post, 'UniformOutput', false);
