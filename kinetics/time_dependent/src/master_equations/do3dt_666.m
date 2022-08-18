function res = do3dt_666(transition_matrix_m3_per_s, decay_rates_per_s, ...
  equilibrium_constants_m3, m_conc_per_m3, state_concs_per_m3)
% Evaluates O3 concentration derivatives for given concentrations values and transition matrix
% transition_matrix(i, j) has transition rate constant from j-th to i-th state
% transition_matrix(i, i) has sum of transition rate constants from i-th to all other states
% state_concs is a vector of concentrations for all states of O3
% Total concentrations of O and O2 are stored in the last 2 elements of state_concs

  transition_per_m3_s = transition_matrix_m3_per_s * state_concs_per_m3(1 : end - 2) * m_conc_per_m3;
  formation_per_m3_s = decay_rates_per_s .* equilibrium_constants_m3 * ...
    state_concs_per_m3(end - 1) * state_concs_per_m3(end);
  decay_per_m3_s = decay_rates_per_s .* state_concs_per_m3(1 : end - 2);

  derivatives_per_m3_s = zeros(size(state_concs_per_m3));
  derivatives_per_m3_s(1 : end - 2) = transition_per_m3_s + formation_per_m3_s - decay_per_m3_s;
  derivatives_per_m3_s(end - 1) = sum(decay_per_m3_s) - sum(formation_per_m3_s);
  derivatives_per_m3_s(end) = derivatives_per_m3_s(end - 1);

  res = derivatives_per_m3_s;
end