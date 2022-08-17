function transition_matrix_m3_per_s = calculate_transition_matrix(o3_molecule, temp_k, sigma0_m2, states, dE_j, ...
  optional)
% Calculates state-to-state transition matrix (matrix(i, j) = k_(i->j))
% dE = [down, up]
  k0_tran_m3_per_s = get_k0_2(o3_molecule, temp_k, sigma0_m2);
  transition_matrix_m3_per_s = k0_tran_m3_per_s * calculate_transition_matrix_unitless(states, dE_j, optional);
end