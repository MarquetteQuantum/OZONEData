function res = do3dt_686(transition_matrix_m3_per_s, decay_rates_ch1_per_s, decay_rates_ch2_per_s, ...
  equilibrium_constants_ch1_m3, equilibrium_constants_ch2_m3, m_conc_per_m3, state_concs_per_m3)
% Evaluates O3 full concentration derivatives for given concentrations values and transition matrix
% transition_matrix(i, j) has full transition rate constant from j-th to i-th state
% transition_matrix(i, i) has negative sum of full transition rate constants from i-th to all other states
% state_concs is a vector of full concentrations for all states of O3
% Total concentrations of 8, 66, 6 and 68 are stored in the last 4 elements of state_concs in this order

  transition_per_m3_s = transition_matrix_m3_per_s * state_concs_per_m3(1 : end - 4) * m_conc_per_m3;
  formation_ch1_per_m3_s = decay_rates_ch1_per_s .* equilibrium_constants_ch1_m3 * ...
    state_concs_per_m3(end - 3) * state_concs_per_m3(end - 2);
  decay_ch1_per_m3_s = decay_rates_ch1_per_s .* state_concs_per_m3(1 : end - 4);
  formation_ch2_per_m3_s = decay_rates_ch2_per_s .* equilibrium_constants_ch2_m3 * ...
    state_concs_per_m3(end - 1) * state_concs_per_m3(end);
  decay_ch2_per_m3_s = decay_rates_ch2_per_s .* state_concs_per_m3(1 : end - 4);

  derivatives_per_m3_s = zeros(size(state_concs_per_m3));
  derivatives_per_m3_s(1 : end - 4) = transition_per_m3_s + formation_ch1_per_m3_s + formation_ch2_per_m3_s - ...
    decay_ch1_per_m3_s - decay_ch2_per_m3_s;
  derivatives_per_m3_s(end - 3) = sum(decay_ch1_per_m3_s) - sum(formation_ch1_per_m3_s);
  derivatives_per_m3_s(end - 2) = derivatives_per_m3_s(end - 3);
  derivatives_per_m3_s(end - 1) = sum(decay_ch2_per_m3_s) - sum(formation_ch2_per_m3_s);
  derivatives_per_m3_s(end) = derivatives_per_m3_s(end - 1);

  res = derivatives_per_m3_s;
end