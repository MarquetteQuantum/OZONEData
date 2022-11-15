function [ref_energy_j, lowest_threshold_energy_j] = get_higher_barrier_threshold(barriers_prefix, o3_molecule, J, K, ...
  vib_sym_well)
% Returns max of lowest threshold energy and lowest barrier energy
  barrier_energy_j = estimate_lowest_barrier_energy(barriers_prefix, o3_molecule, J, K);
  threshold_energies_j = get_threshold_energies(o3_molecule, K, vib_sym_well, K_dependent_threshold=true);
  ch_ind = get_lower_channel_ind(o3_molecule);
  lowest_threshold_energy_j = threshold_energies_j(ch_ind);
  ref_energy_j = max(barrier_energy_j, lowest_threshold_energy_j);
end