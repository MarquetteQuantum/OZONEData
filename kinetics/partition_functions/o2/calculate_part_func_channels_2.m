function part_funcs_o2_per_m3 = calculate_part_func_channels_2(o3_molecule, states, temp_k, optional)
% Calculates partition functions for the channels of a given O3 molecule for all given Ks
  [~, threshold_js] = get_threshold_energies_2(o3_molecule, states, optional);
  part_funcs_o2_per_m3 = calculate_part_func_channels(o3_molecule, threshold_js, temp_k);
end