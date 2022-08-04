function resonances = read_resonances(data_path, format, optional)
% Combines reading and kinetic transformation of resonances.
  if nargin < nargin(@read_resonances)
    optional = nan;
  end
  header_lines = iif(format == "alex", 0, 1);
  resonances = get_or_default(optional, 'resonances', map_create());
  recursive_read_all_flat(data_path, header_lines, resonances, optional);
  transform_kinetic_data_all_flat(resonances, format);
end