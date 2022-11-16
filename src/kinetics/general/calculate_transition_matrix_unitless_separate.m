function matrix = calculate_transition_matrix_unitless_separate(states, dE_j, region_names, alpha0, optional)
% Calculates unitless state-to-state transition matrix (matrix(i, j) = kappa i->j)
% dE = [down, up]
% alpha0 is from 0 to 1 and controls efficiency of cross-region transitions
  arguments
    states
    dE_j
    region_names
    alpha0
    optional.region_factors = ones(size(region_names))
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
        alpha = 3 * alpha0 * ...
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

      matrix(i, j) = ptran * exp(energy_diff / dE_j(dE_ind));
      matrix(j, i) = ptran * exp(-energy_diff / dE_j(3 - dE_ind));
    end
  end
end