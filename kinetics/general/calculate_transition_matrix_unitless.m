function matrix = calculate_transition_matrix_unitless(states, dE_j, transition_model)
% Calculates unitless state-to-state transition matrix (matrix(i, j) = kappa i->j)
% dE = [down, up]
% Transition model is a cell array of cell arrays. Each internal array specifies a group of columns that can transit to
% one another. E.g. {{'sym'}, {'asym'}, {'vdw_a_sym', 'vdw_a_asym'}, {'vdw_b'}}
  matrix = zeros(size(states, 1));
  energies_j = states{:, 'energy'};
  probs = select_region_probabilities(states, transition_model);
  
  for j = 1 : size(matrix, 2)
    for i = 1 : j-1
      ptran = dot(probs(i, :), probs(j, :));
      matrix(i, j) = ptran * exp((energies_j(i) - energies_j(j)) / dE_j(2));
      matrix(j, i) = ptran * exp((energies_j(j) - energies_j(i)) / dE_j(1));
    end
  end
end

function probs = select_region_probabilities(states, transition_model)
% Merges region probabilities according to the groups specified in transition_model
  probs = zeros(size(states, 1), length(transition_model));
  for i = 1:length(transition_model)
    probs(:, i) = sum(states{:, transition_model{i}}, 2);
  end
end