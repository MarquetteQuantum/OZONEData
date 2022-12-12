function matrix = calculate_transition_matrix_unitless_separate(states, dE_j, region_names, alpha0, optional)
% Calculates unitless state-to-state transition matrix (matrix(i, j) = kappa i->j)
% dE = [down, up]
% alpha0 controls efficiency of cross-region transitions
% alpha0 can be a matrix of alpha values for each type of cross-transition or a scalar, which is interpreted as a constant matrix 
% Transitions within regions are unaffected by alpha0 regardless of the values of the diagonal entries
  arguments
    states
    dE_j
    region_names
    alpha0
    optional.region_factors = ones(size(region_names))
  end

  if length(alpha0) == 1
    alpha0 = alpha0 * ones(length(region_names));
  end
  block_size = [size(states, 1), length(region_names)];
  matrix = zeros(prod(block_size));
  energies_j = states{:, "energy"};
  probs = states{:, region_names};
  
  for j = 1 : size(matrix, 2)
    [state_col, region_col] = ind2sub(block_size, j);
    for i = 1 : j-1
      [state_row, region_row] = ind2sub(block_size, i);

      ptran = probs(state_row, region_row) * probs(state_col, region_col);
      if region_row == region_col
        ptran = ptran / optional.region_factors(region_row);
      else
        alpha = 3 * alpha0(region_row, region_col) * ...
          (probs(state_row, region_row) * probs(state_col, region_row) / optional.region_factors(region_row) + ...
          probs(state_row, region_col) * probs(state_col, region_col) / optional.region_factors(region_col));
        ptran = ptran * alpha / optional.region_factors(region_row) / optional.region_factors(region_col);
      end

      energy_diff = energies_j(state_row) - energies_j(state_col);
      if energy_diff < 0
        dE_ind = 2;
      else
        dE_ind = 1;
      end

      matrix(i, j) = probs(state_col, region_col) * ptran * exp(energy_diff / dE_j(dE_ind));
      matrix(j, i) = probs(state_row, region_row) * ptran * exp(-energy_diff / dE_j(end + 1 - dE_ind));
    end
  end
end