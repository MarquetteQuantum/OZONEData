function kdecs_per_s = get_decay_coeffs_2(o3_molecule, states, optional)
  arguments
    o3_molecule
    states
    optional.K_dependent_threshold = false
  end

  [threshold_energies_j, ~] = get_threshold_energies_2(o3_molecule, states, ...
    K_dependent_threshold=optional.K_dependent_threshold);
  kdecs_per_s = get_decay_coeffs(o3_molecule, states, threshold_energies_j);
end