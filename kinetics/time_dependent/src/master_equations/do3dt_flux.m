function res = do3dt_flux(transition_matrix_m3_per_s, m_conc_per_m3, first_unbound_ind, state_concs_per_m3)
% Calculates fluxes in and out of the bound O3 states
% transition_matrix(i, j) has transition rate constant from i-th to j-th state
% state_concs is a vector of concentrations for all states of O3
% Total concentrations of O and O2 are stored in the last 2 elements of state_concs

  transition_influx_bound_per_m3_s = transition_matrix_m3_per_s(1 : first_unbound_ind - 1, :)' * ...
    state_concs_per_m3(1 : first_unbound_ind - 1) * m_conc_per_m3; % transition influx to all from bound
  transition_influx_unbound_per_m3_s = transition_matrix_m3_per_s(first_unbound_ind : end, :)' * ...
    state_concs_per_m3(first_unbound_ind : end - 2) * m_conc_per_m3; % transition influx to all from unbound

  res = {transition_influx_bound_per_m3_s, transition_influx_unbound_per_m3_s};
end