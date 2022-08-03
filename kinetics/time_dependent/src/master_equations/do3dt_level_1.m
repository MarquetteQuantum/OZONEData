function res = do3dt_level_1(transition_matrix_m3_per_s, m_conc_per_m3, ...
  first_unbound_ind, o3_concs_per_m3)
% Evaluates O3 concentration derivatives for given concentrations values and transition matrix
% transition_matrix(i, j) has transition rate constant from i-th to j-th state

  influx_bound_per_m3_s = transition_matrix_m3_per_s(1 : first_unbound_ind - 1, :)' * ...
    o3_concs_per_m3(1 : first_unbound_ind - 1) * m_conc_per_m3; % influx to all from bound
  influx_unbound_per_m3_s = transition_matrix_m3_per_s(first_unbound_ind : end, :)' * ...
    o3_concs_per_m3(first_unbound_ind : end) * m_conc_per_m3; % influx to all from unbound
  outflux_bound_per_m3_s = sum(transition_matrix_m3_per_s(:, 1 : first_unbound_ind - 1), 2) .* ...
    o3_concs_per_m3 * m_conc_per_m3; % outflux from all to bound
  outflux_unbound_per_m3_s = sum(transition_matrix_m3_per_s(:, first_unbound_ind : end), 2) .* ...
    o3_concs_per_m3 * m_conc_per_m3; % outflux from all to unbound
  total_influx_per_m3_s = influx_bound_per_m3_s + influx_unbound_per_m3_s;
  total_outflux_per_m3_s = outflux_bound_per_m3_s + outflux_unbound_per_m3_s;
  derivatives_per_m3_s = total_influx_per_m3_s - total_outflux_per_m3_s;
  res = {derivatives_per_m3_s, influx_bound_per_m3_s, influx_unbound_per_m3_s, ...
    outflux_bound_per_m3_s, outflux_unbound_per_m3_s};

%   total_influx_per_m3_s = transition_matrix_m3_per_s' * o3_concs_per_m3 * m_conc_per_m3;
%   total_outflux_per_m3_s = sum(transition_matrix_m3_per_s, 2) .* o3_concs_per_m3 * m_conc_per_m3;
%   derivatives_per_m3_s = total_influx_per_m3_s - total_outflux_per_m3_s;

%   flux_matrix_per_s = (transition_matrix_m3_per_s' - diag(sum(transition_matrix_m3_per_s, 2))) * ...
%     m_conc_per_m3;

%   res = {derivatives_per_m3_s};
end