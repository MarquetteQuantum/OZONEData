function [ref_energy_j, lower_threshold_energy_j] = get_higher_barrier_threshold(o3_molecule, J, K, vib_sym_well)
% Returns max of lower threshold energy and barrier energy
  barrier_energy_j = estimate_barrier_energy(o3_molecule, J, K);
  threshold_energies_j = get_threshold_energies(o3_molecule, K, vib_sym_well, K_dependent_threshold=true);
  ch_ind = get_lower_channel_ind(o3_molecule);
  lower_threshold_energy_j = threshold_energies_j(ch_ind);
  ref_energy_j = max(barrier_energy_j, lower_threshold_energy_j);
end