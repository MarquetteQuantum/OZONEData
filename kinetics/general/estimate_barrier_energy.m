function energy = estimate_barrier_energy(states)
% Approximates barrier energy as the energy of the first state with sufficiently large gamma
  energy = states{find(states{:, 'gamma_total'} > 1 * getvar('j_per_cm_1'), 1), 'energy'};
end