function [krec_sym_m6_per_s, krec_asym_m6_per_s] = find_krec_eig_686(o3_molecule, temp_k, sigma0_m2, states, dE_j, ...
  M_per_m3, transition_model, name_sym, name_asym, optional)
% Finds krec via solution of an eigenproblem
  kdis_per_s = find_kdis_eig_686(o3_molecule, temp_k, sigma0_m2, states, dE_j, M_per_m3, transition_model, optional);
  Keqs_total_m3 = calculate_formation_decay_equilibrium_2(o3_molecule, states, temp_k, optional);
  Keqs_sym_m3 = sum(Keqs_total_m3(:, 2) .* states{:, name_sym});
  Keqs_asym_m3 = sum(Keqs_total_m3(:, 2) .* states{:, name_asym});
  krec_sym_m6_per_s = Keqs_sym_m3 * kdis_per_s / M_per_m3;
  krec_asym_m6_per_s = Keqs_asym_m3 * kdis_per_s / M_per_m3;
end