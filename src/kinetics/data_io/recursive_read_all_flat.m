function new_keys = recursive_read_all_flat(path, header_lines, map, optional)
% Similar to recursive_read_all but uses file path after delimiter as a key and stores all data on
% the same level and reads new data format. Skips *header_lines* lines.
% The values of J, p, K0_sym and K are taken from corresponding folder names.
  arguments
    path
    header_lines
    map
    optional.delim = path
    optional.follow_links = true
    optional.add_new_only = false
    optional.include_num_levels = 0
  end

  new_keys = recursive_read_all_flat_core(path, header_lines, map, optional.delim, ...
    follow_links=optional.follow_links, add_new_only=optional.add_new_only, ...
    include_num_levels=optional.include_num_levels);
end

function new_keys = recursive_read_all_flat_core(path, header_lines, map, delim, optional)
  arguments
    path
    header_lines
    map
    delim
    optional.follow_links = true
    optional.add_new_only = false
    optional.include_num_levels = 0
  end
  
  new_keys = {};
  dir_content = dir(path);
  for i = 1:length(dir_content)
    next_record = dir_content(i);
    file_name = next_record.name;
    if startsWith(file_name, '.')
      continue
    end
    full_path = fullfile(path, file_name);

    if next_record.isdir || endsWith(full_path, '.link') && optional.follow_links
      if endsWith(full_path, '.link')
        full_path = fileread(full_path); % follow link
      end
      next_new_keys = recursive_read_all_flat_core(full_path, header_lines, map, delim, ...
        follow_links=optional.follow_links, add_new_only=optional.add_new_only, ...
        include_num_levels=optional.include_num_levels);
      new_keys = [new_keys, next_new_keys];
    else
      delim_pos = strfind(full_path, delim);
      if optional.include_num_levels > 0
        first_include_pos = find(delim == filesep, optional.include_num_levels, 'last');
      else
        first_include_pos = length(delim);
      end
      key = full_path(delim_pos + first_include_pos(1) : end - length(file_name) - 1);
      if optional.add_new_only && isKey(map, key)
        continue
      end
      file_content = dlmread(full_path, '', header_lines, 0);
      map(key) = file_content;
      new_keys = {key};
    end
  end
end