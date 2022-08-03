function kdis_per_s = find_kdis_eig(o3_molecule, temp_k, sigma0_m2, states, dE_j, M_per_m3, optional)
% Finds kdis via solution of an eigenproblem
  decay_coeffs_per_s = get_decay_coeffs_2(o3_molecule, states, optional);
  transition_matrix_m3_per_s = calculate_transition_matrix(o3_molecule, temp_k, sigma0_m2, states, dE_j);
  kdis_matrix_per_s = -M_per_m3 * transition_matrix_m3_per_s';
  kdis_matrix_per_s = kdis_matrix_per_s + diag(decay_coeffs_per_s + M_per_m3 * sum(transition_matrix_m3_per_s, 2));
  [~, eivals] = eig(kdis_matrix_per_s);
  kdis_per_s = min(diag(eivals));
end