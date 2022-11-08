function resonances = read_resonances(data_path, format, optional)
% Recursively reads all resonances starting from a given path and applies kinetic transformation.
  arguments
    data_path
    format
    optional.resonances = map_create()
    optional.delim = data_path
    optional.follow_links = true
    optional.add_new_only = false
    optional.include_num_levels = 0
  end

  header_lines = iif(format == "alex", 0, 1);
  resonances = optional.resonances;
  new_keys = recursive_read_all_flat(data_path, header_lines, resonances, delim=optional.delim, ...
    follow_links=optional.follow_links, add_new_only=optional.add_new_only, ...
    include_num_levels=optional.include_num_levels);
  transform_kinetic_data_all_flat(resonances, format, map_keys=new_keys);
end