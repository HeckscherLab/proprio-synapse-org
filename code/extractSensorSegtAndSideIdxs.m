function idxs = extractSensorSegtAndSideIdxs(names)
% For pulling known groupings of proprioceptors.
    idxs.dbd  = contains(names, 'dbd');
    idxs.ddaD = contains(names, 'ddaD');
    idxs.ddaE = contains(names, 'ddaE');
    idxs.dmd1 = contains(names, 'dmd1');
    idxs.vpda = contains(names, 'vpda');
    idxs.vbd  = contains(names, 'vbd');
    
    idxs.T3   = contains(names, ("t3"+("l"|"r")));
    idxs.A1   = contains(names, ("a1"+("l"|"r")));
    idxs.A2   = contains(names, ("a2"+("l"|"r")));
    idxs.A3   = contains(names, ("a3"+("l"|"r")));
    idxs.A4   = contains(names, ("a4"+("l"|"r")));
    
    idxs.L    = contains(names, (("t3"|"a1"|"a2"|"a3"|"a4") + "l"));
    idxs.R    = contains(names, (("t3"|"a1"|"a2"|"a3"|"a4") + "r"));
end