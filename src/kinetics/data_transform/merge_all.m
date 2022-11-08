function merged = merge_all(data_map)
% Merges all data tables within a given map
  data_keys = keys(data_map);
  merged = [];
  for i = 1:length(data_keys)
    merged = vertcat(merged, data_map(data_keys{i}));
  end
end