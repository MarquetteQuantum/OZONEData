function kdis_per_s = find_kdis_eig(o3_molecule, temp_k, sigma0_m2, states, dE_j, M_per_m3, transition_model, ...
  optional)
% Finds kdis by solving an eigenproblem
  arguments
    o3_molecule
    temp_k
    sigma0_m2
    states
    dE_j
    M_per_m3
    transition_model
    optional.K_dependent_threshold = false
    optional.check_eigenvectors = false
    optional.max_angle = 1e-3
  end

  channel_decay_coeffs_per_s = get_decay_coeffs_2(o3_molecule, states, ...
    K_dependent_threshold=optional.K_dependent_threshold);
  decay_coeffs_per_s = sum(channel_decay_coeffs_per_s, 2);
  transition_matrix_m3_per_s = calculate_transition_matrix(o3_molecule, temp_k, sigma0_m2, states, dE_j, ...
    transition_model);
  kdis_matrix_per_s = -M_per_m3 * transition_matrix_m3_per_s';
  kdis_matrix_per_s = kdis_matrix_per_s + diag(decay_coeffs_per_s + M_per_m3 * sum(transition_matrix_m3_per_s, 2));
  [eivecs, eivals] = eig(kdis_matrix_per_s);
  eivals = diag(eivals);

  [kdis_per_s, min_ind] = min(eivals);
  if optional.check_eigenvectors
    kdis_eigenvector = eivecs(:, min_ind);
    angle = get_eigenvector_angle(kdis_matrix_per_s, kdis_eigenvector);
    if angle > optional.max_angle
      error("All considered eigenvectors are bad")
    end
  else
    kdis_per_s = max([kdis_per_s, 0]);
  end
end