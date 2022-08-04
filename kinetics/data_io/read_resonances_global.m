function read_resonances_global()
% data_path - path to folder with molecule data, e.g. .../resonances/mol_666
% format - either 666 or 686 (also applies to 676)
  data_sets = {'666', '676', '686'};
  formats = {'666', '686', '686'};
  varname = 'resonances';
  
  optional = map_create();
  optional('include_num_levels') = 1; % number of folders from the end of path to include in each key
  
  resonances = [];
  for i = 1:length(data_sets)
    data_path = ['resonances\mol_', data_sets{i}];
    new_resonances = read_resonances(data_path, formats{i}, optional);
    resonances = [resonances; new_resonances];
  end
  
  assignin('base', varname, resonances);
end