function [ref_energy_j, lowest_threshold_energy_j] = get_higher_barrier_threshold_2(o3_molecule, J, K, vib_sym_well)
% Returns max of lowest threshold energy and lowest barrier energy
% Assumes constant barrier prefix
  barriers_prefix = [fullfile('data', 'barriers'), filesep];
  [ref_energy_j, lowest_threshold_energy_j] = get_higher_barrier_threshold(barriers_prefix, o3_molecule, J, K, vib_sym_well);
end