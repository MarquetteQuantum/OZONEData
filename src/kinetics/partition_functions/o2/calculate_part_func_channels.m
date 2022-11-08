function part_func_channels_per_m3 = calculate_part_func_channels(o3_molecule, threshold_js, temp_k)
% Calculates partition functions for the channels of a given O3 molecule for all given Ks
  channels = get_ozone_channels(o3_molecule);
  part_func_channels_per_m3 = zeros(size(threshold_js));
  for K_ind = 1:size(threshold_js, 1)
    for sym_ind = 1:size(threshold_js, 2)
      for ch = 1:size(threshold_js, 3)
        o2_j = threshold_js(K_ind, sym_ind, ch);
        part_func_channels_per_m3(K_ind, sym_ind, ch) = ...
          calc_part_func_o2_total_mol(temp_k, channels(ch, 2), channels(ch, 1), o2_j);
      end 
    end
  end
end