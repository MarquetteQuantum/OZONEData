function kdecs_per_s = get_decay_coeffs(o3_molecule, states, threshold_energies_j)
% Returns decay coefficients for given states. Columns correspond to channels.
  hbar_js = get_hbar_js();
  if o3_molecule == "666"
    kdecs_per_s = states{:, 'gamma_total'} / hbar_js;
  else
    kdecs_per_s = zeros(size(states, 1), 2);
    kdecs_per_s(:, 1) = states{:, 'gamma_b'} / hbar_js;
    kdecs_per_s(:, 2) = states{:, 'gamma_a'} / hbar_js;
  end
  
  for K_ind = 1:size(threshold_energies_j, 1)
    for sym_ind = 1:size(threshold_energies_j, 2)
      subset_inds = states{:, 'K_ind'} == K_ind & states{:, 'vib_sym_well_ind'} == sym_ind;
      for ch = 1:size(threshold_energies_j, 3)
        bound_subset_inds = ...
          subset_inds & states{:, 'energy'} < threshold_energies_j(K_ind, sym_ind, ch);
        kdecs_per_s(bound_subset_inds, ch) = 0;
      end
    end
  end
end