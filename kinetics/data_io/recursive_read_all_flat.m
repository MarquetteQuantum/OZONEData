function recursive_read_all_flat(path, header_lines, map, optional)
% Similar to recursive_read_all but uses file path after delimiter as a key and stores all data on
% the same level and reads new data format. Skips *header_lines* lines.
% The values of J, p, K0_sym and K are taken from corresponding folder names.
  if nargin < nargin(@recursive_read_all_flat)
    optional = nan;
  end
  if ~endsWith(path, '\')
    path = [path, '\'];
  end
  recursive_read_all_flat_core(path, header_lines, map, optional, path);
end

function recursive_read_all_flat_core(path, header_lines, map, optional, delim)
  follow_links = get_or_default(optional, 'follow_links', 1);
  add_new_only = get_or_default(optional, 'add_new_only', 0);
  include_num_levels = get_or_default(optional, 'include_num_levels', 0);
  
  dir_content = dir(path);
  for i = 1:length(dir_content)
    next_record = dir_content(i);
    file_name = next_record.name;
    if startsWith(file_name, '.')
      continue
    end
    full_path = fullfile(path, file_name);

    if next_record.isdir || endsWith(full_path, '.link') && follow_links == 1
      if endsWith(full_path, '.link')
        full_path = fileread(full_path); % follow link
      end
      recursive_read_all_flat_core(full_path, header_lines, map, optional, delim);
    else
      delim_pos = strfind(full_path, delim);
      first_include_pos = find(delim == '\', include_num_levels + 1, 'last');
      key = full_path(delim_pos + first_include_pos(1) : end - length(file_name) - 1);
      if add_new_only == 1 && isKey(map, key)
        continue
      end
      file_content = dlmread(full_path, '', header_lines, 0);
      map(key) = file_content;
    end
  end
end