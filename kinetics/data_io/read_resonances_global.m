function read_resonances_global()
% 686 format is applicable to all heteroatomic molecules
  data_sets = {'666', '676', '686'};
  formats = {'666', '686', '686'};
  varname = 'resonances';
  
  optional = map_create();
  optional('include_num_levels') = 1; % number of folders from the end of path to include in each key
  
  resonances = [];
  for i = 1:length(data_sets)
    data_path = ['data\resonances\mol_', data_sets{i}];
    new_resonances = read_resonances(data_path, formats{i}, optional);
    resonances = [resonances; new_resonances];
  end
  
  assignin('base', varname, resonances);
end