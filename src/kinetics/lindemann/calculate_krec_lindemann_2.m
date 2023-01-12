function krec_m6_per_s = calculate_krec_lindemann_2(o3_molecule, states, temp_k, M_conc_per_m3, sigma_m2, dE_j, region_names, region_factors)
% Calculates krec under Lindemann assumptions
  decay_coeffs_per_s = sum(get_decay_coeffs_2(o3_molecule, states), 2);
  bound = states{:, "gamma_total"} == 0;

  transition_matrix_m3_per_s = calculate_transition_matrix(o3_molecule, temp_k, sigma_m2, states, dE_j, region_names, region_factors);
  ktrans_ub_m3_per_s = zeros(size(states, 1), 1);
  ktrans_ub_m3_per_s(~bound) = sum(transition_matrix_m3_per_s(~bound, bound), 2);

  weights = calculate_weights(decay_coeffs_per_s, ktrans_ub_m3_per_s, M_conc_per_m3);
  equilibrium_constants_m3 = calculate_formation_decay_equilibrium_2(o3_molecule, states, temp_k);

  transition_matrix_cov_m3_per_s = transition_matrix_m3_per_s .* states{:, "cov"}';
  ktrans_ub_cov_m3_per_s = zeros(size(states, 1), 1);
  ktrans_ub_cov_m3_per_s(~bound) = sum(transition_matrix_cov_m3_per_s(~bound, bound), 2);

  krec_m6_per_s = calculate_krec_lindemann(weights, equilibrium_constants_m3, ktrans_ub_cov_m3_per_s);
end