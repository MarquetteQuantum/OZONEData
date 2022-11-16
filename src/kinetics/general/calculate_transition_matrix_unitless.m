function matrix = calculate_transition_matrix_unitless(states, dE_j, region_names, optional)
% Calculates unitless state-to-state transition matrix (matrix(i, j) = kappa i->j)
% dE = [down, up]
  arguments
    states
    dE_j
    region_names
    optional.region_factors = ones(size(region_names))
  end

  matrix = zeros(size(states, 1));
  energies_j = states{:, 'energy'};
  probs = states{:, region_names};
  
  for j = 1 : size(matrix, 2)
    for i = 1 : j-1
      ptran = sum(probs(i, :) .* probs(j, :) ./ optional.region_factors);
      matrix(i, j) = ptran * exp((energies_j(i) - energies_j(j)) / dE_j(2));
      matrix(j, i) = ptran * exp((energies_j(j) - energies_j(i)) / dE_j(1));
    end
  end
end