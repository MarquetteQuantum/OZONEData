function Kfds_m3 = calculate_formation_decay_equilibrium(states, temp_k, part_funcs_o2_m_3, ...
  threshold_energies_j, optional)
% Calculates formation/decay equilibrium constants for all channels
% 1st column - channel 1, 2nd - channel 2 (not used for 666)
  j_per_k = getvar('j_per_k');
  calc_q = get_or_default(optional, 'calc_q', false);
  kt_energy_j = temp_k * j_per_k;
  
  Kfds_m3 = zeros(size(states, 1), size(threshold_energies_j, 3));
  for K_ind = 1:size(threshold_energies_j, 1)
    for sym_ind = 1:size(threshold_energies_j, 2)
      inds = states{:, 'K_ind'} == K_ind & states{:, 'vib_sym_well_ind'} == sym_ind;
      for ch = 1:size(threshold_energies_j, 3)
        threshold_energy_j = threshold_energies_j(K_ind, sym_ind, ch);
        [~, part_funcs_o3_i] = calc_part_func_plain(...
          states{inds, 'energy'}, 2*states{inds, 'J'} + 1, threshold_energy_j, kt_energy_j);
        Kfds_m3(inds, ch) = part_funcs_o3_i;

        if ~calc_q
          Kfds_m3(inds, ch) = part_funcs_o3_i / part_funcs_o2_m_3(K_ind, sym_ind, ch);
        end
      end
    end
  end
end