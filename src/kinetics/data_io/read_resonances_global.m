function read_resonances_global()
% 686 format is applicable to all heteroatomic molecules
  data_sets = {'666', '676', '686'};
  formats = {'666', '686', '686'};
  varname = 'resonances';
  
  resonances = [];
  for i = 1:length(data_sets)
    data_path = fullfile('data', 'resonances', ['mol_', data_sets{i}]);
    new_resonances = read_resonances(data_path, formats{i}, include_num_levels=1);
    resonances = [resonances; new_resonances];
  end
  
  assignin('base', varname, resonances);
end