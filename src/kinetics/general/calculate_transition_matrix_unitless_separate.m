function matrix = calculate_transition_matrix_unitless_separate(states, dE_j, region_names, alpha0)
% Calculates unitless state-to-state transition matrix (matrix(i, j) = kappa i->j)
% dE = [down, up]
% alpha0 is from 0 to 1 and controls efficiency of cross-region transitions

  block_size = [size(states, 1), length(region_names)];
  matrix = zeros(prod(block_size));
  energies_j = states{:, 'energy'};
  probs = states{:, region_names};
  [~, asym_ind] = ismember("asym", region_names);
  if asym_ind ~= 0
    probs(:, asym_ind) = probs(:, asym_ind) / 2;
  end
  
  for j = 1 : size(matrix, 2)
    [state_col, region_col] = ind2sub(block_size, j);
    for i = 1 : j-1
      [state_row, region_row] = ind2sub(block_size, i);

      ptran = probs(state_row, region_row) * probs(state_col, region_col);
      if region_row == asym_ind || region_col == asym_ind
        ptran = ptran * 2;
      end
      if region_row ~= region_col
        vertical_transitions = [probs(state_row, region_row) * probs(state_col, region_row), ...
          probs(state_row, region_col) * probs(state_col, region_col)];
        asym_region = [region_row, region_col] == asym_ind;
        vertical_transitions(asym_region) = vertical_transitions(asym_region) * 2;
        alpha = 3 * alpha0 * sum(vertical_transitions);
        ptran = ptran * alpha;
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