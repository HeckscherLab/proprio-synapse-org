function [choIn, choOut, mdsIn, mdsOut] = cleanAndFormatChosMdIVs(choIn, choOut, mdsIn, mdsOut)
% All data are subsetted to just sensors from T3-A2.

% Redo mdIV struct idxing to use mdIV names rather than proprio names:
  mdsIn.idxs.pre  = extractMdIVSegtAndSideIdxs(mdsIn.lookup.preName);
  mdsIn.idxs.post = extractMdIVSegtAndSideIdxs(mdsIn.lookup.postName);
  mdsOut.idxs.pre = extractMdIVSegtAndSideIdxs(mdsOut.lookup.preName);
  mdsOut.idxs.post = extractMdIVSegtAndSideIdxs(mdsOut.lookup.postName);
    % NOTE: subfxn not currently looking for anything (incl inputs/outputs) from
    % A4 or further posterior.

% Redo Cho struct idxing to use Cho names rather than Pro names:
  choIn.idxs.pre  = extractChoSegtAndSideIdxs(choIn.lookup.preName);
  choIn.idxs.post = extractChoSegtAndSideIdxs(choIn.lookup.postName);
  choOut.idxs.pre = extractChoSegtAndSideIdxs(choOut.lookup.preName);
  choOut.idxs.post = extractChoSegtAndSideIdxs(choOut.lookup.postName);

% Restrict chos, mdIV data to just T3 - A2:
    segtsToKeep = ["T3", "A1", "A2"];
  choIn  = subsetBySegt(choIn, segtsToKeep, false);
  mdsIn  = subsetBySegt(mdsIn, segtsToKeep, false);  % false: look for mds in idxs.post
  choOut = subsetBySegt(choOut, segtsToKeep, true);
  mdsOut = subsetBySegt(mdsOut, segtsToKeep, true);  % true: look for mds in idxs.pre

 % Clean up cho data:
    choGroups = [choIn.idxs.post.lch5_1, choIn.idxs.post.lch5_2_4, choIn.idxs.post.lch5_3, ...
                 choIn.idxs.post.lch5_3_5, choIn.idxs.post.lch5_5, choIn.idxs.post.vch, choIn.idxs.post.v_ch];
    pointsToRemove = ~any(choGroups, 2);
  choIn = removeSelectedIdxsAndLocs(choIn, pointsToRemove);

    choGroups = [choOut.idxs.pre.lch5_1, choOut.idxs.pre.lch5_2_4, choOut.idxs.pre.lch5_3, ...
                 choOut.idxs.pre.lch5_3_5, choOut.idxs.pre.lch5_5, choOut.idxs.pre.vch, choOut.idxs.pre.v_ch];
    pointsToRemove = ~any(choGroups, 2);
  choOut = removeSelectedIdxsAndLocs(choOut, pointsToRemove);

% 2023 04-12: Include "lch5-3/5" inside "lch5-5", based on where
% the output synapses are in both. Let's combine those.
  choIn  = addLch5_3_5ToLch5_5(choIn, false);  % false: look for chos in idxs.post
  choOut = addLch5_3_5ToLch5_5(choOut, true);  % true: look for chos in idxs.pre
    % I already removed from list of names further up.
end


%% SUBFXNS

function idxs = extractChoSegtAndSideIdxs(names)
% For pulling known groupings of chordotonals.
  excludePatt = ("?"|"or"|"ish"|"projection"|"PN");
    idxs.lch5_1 = contains(names, 'lch5-1') &~ contains(names, excludePatt);
    idxs.lch5_2_4 = contains(names, 'lch5-2/4') &~ contains(names, excludePatt);
    idxs.lch5_3 = contains(names, 'lch5-3 ') &~ contains(names, excludePatt);
    idxs.lch5_3_5 = contains(names, 'lch5-3/5') &~ contains(names, excludePatt);
    idxs.lch5_5 = contains(names, 'lch5-5') &~ contains(names, excludePatt);
    idxs.vch  = contains(names, 'vch') &~ contains(names, excludePatt);
    idxs.v_ch = contains(names, 'v''ch') &~ contains(names, excludePatt);
    
    idxs.T2   = contains(names, ("t2"+("l"|"r"))) &~ contains(names, excludePatt);
    idxs.T3   = contains(names, ("t3"+("l"|"r"))) &~ contains(names, excludePatt);
    idxs.A1   = contains(names, ("a1"+("l"|"r"))) &~ contains(names, excludePatt);
    idxs.A2   = contains(names, ("a2"+("l"|"r"))) &~ contains(names, excludePatt);
    idxs.A3   = contains(names, ("a3"+("l"|"r"))) &~ contains(names, excludePatt);
    idxs.A4   = contains(names, ("a4"+("l"|"r"))) &~ contains(names, excludePatt);
    idxs.A5   = contains(names, ("a5"+("l"|"r"))) &~ contains(names, excludePatt);
    idxs.A6   = contains(names, ("a6"+("l"|"r"))) &~ contains(names, excludePatt);
    idxs.A7   = contains(names, ("a7"+("l"|"r"))) &~ contains(names, excludePatt);
    
    idxs.L    = contains(names, (("t2"|"t3"|"a1"|"a2"|"a3") + "l")) &~ contains(names, excludePatt);
    idxs.R    = contains(names, (("t2"|"t3"|"a1"|"a2"|"a3") + "r")) &~ contains(names, excludePatt);
end

function data = addLch5_3_5ToLch5_5(data, usePre)
% If usePre = true: look for the chordotonal idxs in presynaptic partners.
% If usePre = false: look in the postsynaptic idxs instead.
  if usePre
     lch5_3_5idxs = data.idxs.pre.lch5_3_5;
     lch5_5idxs   = data.idxs.pre.lch5_5;
       % Transfer these to lch5_5, and delete the field with lch5_3_5 idxs:
       lch5_5idxs = lch5_5idxs | lch5_3_5idxs;
     data.idxs.pre.lch5_5 = lch5_5idxs;
     data.idxs.pre  = rmfield(data.idxs.pre, 'lch5_3_5');
     data.idxs.post = rmfield(data.idxs.post, 'lch5_3_5');
  else
     lch5_3_5idxs = data.idxs.post.lch5_3_5;
     lch5_5idxs   = data.idxs.post.lch5_5;
       % Transfer these to lch5_5, and delete the field with lch5_3_5 idxs:
       lch5_5idxs = lch5_5idxs | lch5_3_5idxs;
     data.idxs.post.lch5_5 = lch5_5idxs;
     data.idxs.pre  = rmfield(data.idxs.pre, 'lch5_3_5');
     data.idxs.post = rmfield(data.idxs.post, 'lch5_3_5');
  end
end

function idxs = extractMdIVSegtAndSideIdxs(names)
% For pulling known groupings of md class IV neurons based on their naming scheme in the connectome.
    idxs.ddaC = contains(names, 'ddaC', 'IgnoreCase', true);
    idxs.v_ada = contains(names, 'v''ada', "IgnoreCase", true);
    idxs.vdaB = contains(names, 'vdaB', "IgnoreCase", true);
    
    idxs.T2   = contains(names, ("t2"+("l"|"r")), 'IgnoreCase', true);
    idxs.T3   = contains(names, ("t3"+("l"|"r")), 'IgnoreCase', true);
    idxs.A1   = contains(names, ("a1"+("l"|"r")), 'IgnoreCase', true);
    idxs.A2   = contains(names, ("a2"+("l"|"r")), 'IgnoreCase', true);
    idxs.A3   = contains(names, ("a3"+("l"|"r")), 'IgnoreCase', true);
    
    idxs.L    = contains(names, (("t2"|"t3"|"a1"|"a2"|"a3") + "l"), 'IgnoreCase', true);
    idxs.R    = contains(names, (("t2"|"t3"|"a1"|"a2"|"a3") + "r"), 'IgnoreCase', true);
end
