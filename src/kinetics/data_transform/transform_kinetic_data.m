function res_table = transform_kinetic_data(data_raw, format, J, Ks, p, K0_sym, is_half_integer)
% Transforms raw data matrix to table form convenient for kinetic calculations
  j_per_cm = get_j_per_cm();

  k_probs = zeros(size(data_raw, 1), J + 1);
  if Ks ~= -1
    if length(Ks) == 1
      k_probs(:, Ks + 1) = 1;
    else
      first_k_col = iif(format == "666", 9, 15);
      k_probs(:, Ks + 1) = data_raw(:, first_k_col:end);
    end
  end
  
  if format == "alex"
    variable_names = {...
      'energy', 'gamma_a', 'gamma_b', ...
      'sym', 'asym', ...
      'vdw_a_sym', 'vdw_a_asym', 'vdw_b', ...
      'k_probs'};
    res_table = table(...
      data_raw(:, 2), max(data_raw(:, 8), 1e-16), max(data_raw(:, 7), 1e-16), ...
      data_raw(:, 9), data_raw(:, 10), ...
      data_raw(:, 12) / 2, data_raw(:, 12) / 2, data_raw(:, 11), ...
      num2cell(k_probs, 2), 'VariableNames', variable_names);

    % add extra columns
    res_table{:, 'inf'} = ...
      1 - sum(res_table{:, {'sym', 'asym', 'vdw_a_sym', 'vdw_a_asym', 'vdw_b'}}, 2);
    
  elseif format == "666"
    variable_names = {...
      'energy', 'gamma_total', 'cov', 'vdw', ...
      'inf', 'A', 'B', 'C', 'k_probs'};
    res_table = table(...
      data_raw(:, 1), max(data_raw(:, 2), 1e-16), data_raw(:, 3), data_raw(:, 4), ...
      data_raw(:, 5), data_raw(:, 6), data_raw(:, 7), data_raw(:, 8), num2cell(k_probs, 2), ...
      'VariableNames', variable_names);
    
    % convert energy units from cm^-1 to J for 666-specific fields
    select_columns = {'energy', 'gamma_total', 'A', 'B', 'C'};
    res_table{:, select_columns} = res_table{:, select_columns} * j_per_cm;
    
  elseif format == "686"
    variable_names = {...
      'energy', 'gamma_a', 'gamma_b', ...
      'sym', 'asym', ...
      'vdw_a_sym', 'vdw_a_asym', 'vdw_b', ...
      'inf', 'A', 'B', 'C', 'k_probs'};
    res_table = table(...
      data_raw(:, 1), max(data_raw(:, 11), 1e-16), max(data_raw(:, 10), 1e-16), ...
      data_raw(:, 5), data_raw(:, 3) + data_raw(:, 4), ...
      data_raw(:, 8), data_raw(:, 7), data_raw(:, 6), ...
      data_raw(:, 9), data_raw(:, 12), data_raw(:, 13), data_raw(:, 14), num2cell(k_probs, 2), ...
      'VariableNames', variable_names);
    
    % multiply due to phi-symmetry
    select_columns = {'gamma_a', 'gamma_b', 'sym', 'asym', 'vdw_a_sym', 'vdw_a_asym', 'vdw_b'};
    res_table{:, select_columns} = res_table{:, select_columns} * 2;
  end
  
  % add extra columns
  res_table{:, 'J'} = J;
  res_table{:, 'p'} = p;
  res_table{:, 'K0_sym'} = K0_sym;
  res_table{:, 'is_half_integer'} = is_half_integer;
  
  if format == "alex" || format == "686"
    % convert energy units from cm^-1 to J
    select_columns = {'energy', 'gamma_a', 'gamma_b', 'A', 'B', 'C'};
    res_table{:, select_columns} = res_table{:, select_columns} * j_per_cm;
    
    % add gamma total
    res_table{:, 'gamma_total'} = res_table{:, 'gamma_a'} + res_table{:, 'gamma_b'};
    res_table = movevars(res_table, 'gamma_total', 'After', 'gamma_b');
  end
end