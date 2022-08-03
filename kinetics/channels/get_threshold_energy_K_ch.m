function [threshold_energy_j, threshold_j] = get_threshold_energy_K_ch(o3_molecule, ...
  o2_molecule, K, K_vib_sym_well, optional)
% Returns threshold energy for a given molecule, channel and K
  channel_shift_j = get_channel_shift(o3_molecule, o2_molecule);
  threshold_j = get_o2_threshold_j(o2_molecule, K, K_vib_sym_well, optional);
  threshold_energy_j = rigid_rotor_energy(threshold_j, get_inertia_moment_2(o2_molecule)) + channel_shift_j;
end