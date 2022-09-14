function energy_j = get_higher_barrier_threshold(o3_molecule, J, K, vib_sym_well)
% Returns either lower threshold energy or barrier energy, whatever is higher
  barrier_energy_j = estimate_barrier_energy(o3_molecule, J, K);
  threshold_energies_j = get_threshold_energies(o3_molecule, K, vib_sym_well, K_dependent_threshold=true);
  energy_j = max(barrier_energy_j, threshold_energies_j(end));
end