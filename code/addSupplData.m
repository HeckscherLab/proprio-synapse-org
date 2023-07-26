function data = addSupplData(data, dataSuppl)
% Merge in the fields from dataSuppl BEFORE running format data function.
  data.pre_names  = cat(2, data.pre_names, dataSuppl.pre_names);
  data.post_names = cat(2, data.post_names, dataSuppl.post_names);
  data.cell_IDs   = cat(1, data.cell_IDs, dataSuppl.cell_IDs);
  data.pre_locs   = cat(1, data.pre_locs, dataSuppl.pre_locs);
  data.post_locs  = cat(1, data.post_locs, dataSuppl.post_locs);
end