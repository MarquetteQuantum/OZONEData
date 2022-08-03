function matrix = calculate_transition_matrix_unitless(states, dE_j)
% Calculates unitless state-to-state transition matrix (matrix(i, j) = kappa i->j)
% dE = [down, up]
  matrix = zeros(size(states, 1));
  energies_j = states{:, 'energy'};
  pcov = states{:, 'cov'};
  pvdw = states{:, 'vdw'};
  
  for j = 1 : size(matrix, 2)
    for i = 1 : j-1
      pstab = pcov(i) * pcov(j) + pvdw(i) * pvdw(j);
      matrix(i, j) = pstab * exp((energies_j(i) - energies_j(j)) / dE_j(2));
      matrix(j, i) = pstab * exp((energies_j(j) - energies_j(i)) / dE_j(1));
    end
  end
end