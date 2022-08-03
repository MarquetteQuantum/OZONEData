function krec_m6_per_s = find_krec_eig(o3_molecule, temp_k, sigma0_m2, states, dE_j, M_per_m3, optional)
% Finds krec via solution of an eigenproblem
  kdis_per_s = find_kdis_eig(o3_molecule, temp_k, sigma0_m2, states, dE_j, M_per_m3, optional);
  [Keqs_m3, ~] = calculate_formation_decay_equilibrium_2(o3_molecule, states, temp_k, optional);
  krec_m6_per_s = sum(Keqs_m3) * kdis_per_s / M_per_m3;
end