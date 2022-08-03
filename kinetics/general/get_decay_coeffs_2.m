function kdecs_per_s = get_decay_coeffs_2(o3_molecule, states, optional)
  [threshold_energies_j, ~] = get_threshold_energies_2(o3_molecule, states, optional);
  kdecs_per_s = get_decay_coeffs(o3_molecule, states, threshold_energies_j);
end