function kdis_per_s = find_kdis_eig(o3_molecule, temp_k, sigma0_m2, states, dE_j, M_per_m3, optional)
% Finds kdis via solution of an eigenproblem
  check_eigenvectors = get_or_default(optional, "check_eigenvectors", true);
  max_eigenvectors = get_or_default(optional, "max_eigenvectors", 1);

  decay_coeffs_per_s = get_decay_coeffs_2(o3_molecule, states, optional);
  transition_matrix_m3_per_s = calculate_transition_matrix(o3_molecule, temp_k, sigma0_m2, states, dE_j);
  kdis_matrix_per_s = -M_per_m3 * transition_matrix_m3_per_s';
  kdis_matrix_per_s = kdis_matrix_per_s + diag(decay_coeffs_per_s + M_per_m3 * sum(transition_matrix_m3_per_s, 2));
  [eivecs, eivals] = eig(kdis_matrix_per_s);
  eivals = diag(eivals);

  if check_eigenvectors
    [~, min_inds] = sort(eivals);
  
    kdis_per_s = nan;
    for i = 1:max_eigenvectors
      next_eigenvector = eivecs(:, min_inds(i));
      if is_eigenvector_good(kdis_matrix_per_s, next_eigenvector)
        kdis_per_s = eivals(min_inds(i));
        break
      end
    end
  
    if isnan(kdis_per_s)
      error("All considered eigenvectors are bad")
    end
  else
    kdis_per_s = min(eivals);
%     eivals = sort(eivals);
%     kdis_per_s = eivals(5);
  end
end