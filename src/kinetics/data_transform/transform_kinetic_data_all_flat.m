function transform_kinetic_data_all_flat(data_map, format, optional)
% Deduces values of J, p and K0_sym from map keys and applies kinetic data transformation to all map items. 
% Assumes data_map is assembled with flat keys.
  arguments
    data_map
    format
    optional.map_keys = keys(data_map)
  end

  for i = 1:length(optional.map_keys)
    next_key = optional.map_keys{i};
    data_raw = data_map(next_key);
    [~, J, Ks, p, K0_sym, is_half_integer] = get_flat_key_info(next_key);
    if p == -1 && all(Ks == 0)
      p = mod(J, 2);
    end
    data = transform_kinetic_data(data_raw, format, J, Ks, p, K0_sym, is_half_integer);
    data_map(next_key) = data;
  end
end