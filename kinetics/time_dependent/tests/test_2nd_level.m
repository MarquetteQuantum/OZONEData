function test_2nd_level()
% Tests the second level of time dependent theory (transitions and formation/decay)
  resonances = getvar('resonances');
  j_per_cm_1 = getvar('j_per_cm_1');
  m_per_a0 = getvar('m_per_a0');
  
  o3_molecule = '666';
  Js = 24;
  Ks = 2;
  syms = 0;
  temp_k = 298;
  M_per_m3 = 6.44e28;
  dE_j = [-43.13, nan] * j_per_cm_1;
  dE_j(2) = get_dE_up(dE_j(1), temp_k);
  sigma0_tran_m2 = 250 * m_per_a0^2;
  time_s = linspace(0, 0.001e-9, 101);
  optional = map_create();
  optional('k_dependent_threshold') = 0;

  key = get_key(o3_molecule, Js, Ks, syms);
  states = resonances(key);
  states = states(states{:, 'energy'} > -3000 * j_per_cm_1, :);
  states = states(states{:, 'energy'} < 300 * j_per_cm_1, :);
%   states = states(states{:, 'gamma_total'} < 1 * j_per_cm_1, :);
  states = assign_extra_properties(o3_molecule, states);
  first_unbound = find(states{:, 'energy'} > 0, 1);

  initial_concentrations_per_m3 = zeros(size(states, 1) + 2, 1);
  initial_concentrations_per_m3(end) = 6.44e20; % [O2]
  initial_concentrations_per_m3(end - 1) = 6.44e18; % [O]

  tic
  [concentrations_per_m3, ode_func, ~, Keqs_m3] = propagate_concentrations(2, o3_molecule, states, ...
    initial_concentrations_per_m3, time_s, sigma0_tran_m2, temp_k, M_per_m3, dE_j, optional);
  toc

  O3_total_per_m3 = sum(concentrations_per_m3(:, 1 : end - 2), 2);
  O3_bound_per_m3 = sum(concentrations_per_m3(:, 1 : first_unbound - 1), 2);
%   O3_unbound_concentration_per_m3 = sum(concentrations_per_m3(:, first_unbound : end - 2), 2);
  O_per_m3 = concentrations_per_m3(:, end - 1);
  O2_per_m3 = concentrations_per_m3(:, end);

  Keq_total_m3 = sum(Keqs_m3);
  Keq_bound_m3 = sum(Keqs_m3(1 : first_unbound - 1));
  coeffs = [Keq_total_m3, ...
    -(1 + Keq_total_m3 * (initial_concentrations_per_m3(end - 1) + initial_concentrations_per_m3(end))), ...
    Keq_total_m3 * initial_concentrations_per_m3(end - 1) * initial_concentrations_per_m3(end)];
  O3_total_equilibrium_per_m3 = get_item(roots(coeffs), 2);
  O3_bound_equilibrium_per_m3 = O3_total_equilibrium_per_m3 * Keq_bound_m3 / Keq_total_m3;
  O_equilibrium_per_m3 = initial_concentrations_per_m3(end - 1) - O3_total_equilibrium_per_m3;
  O2_equilibrium_per_m3 = initial_concentrations_per_m3(end) - O3_total_equilibrium_per_m3;
  
  O3_total_displacement_per_m3 = abs(O3_total_per_m3 - O3_total_equilibrium_per_m3);
  O3_bound_displacement_per_m3 = abs(O3_bound_per_m3 - O3_bound_equilibrium_per_m3);

  dO3dt_per_m3_s = row_function(@(row) ode_func(0, row')', concentrations_per_m3);
  dO3dt_total_per_m3_s = sum(dO3dt_per_m3_s(:, 1 : end - 2), 2);
  dO3dt_bound_per_m3_s = sum(dO3dt_per_m3_s(:, 1 : first_unbound - 1), 2);

  krec_approx_m6_per_s = dO3dt_total_per_m3_s ./ O3_total_displacement_per_m3 * Keq_total_m3 / M_per_m3;
  krec_m6_per_s = dO3dt_total_per_m3_s ./ (O_per_m3 .* O2_per_m3 - O3_total_per_m3 / Keq_total_m3) / M_per_m3;

  krec_approx_m6_per_s(end)
  krec_m6_per_s(end)

  figure_ids = 1:10;
  style = 'b.-';
  x_lims = [time_s(11), time_s(end)] * 1e9;

%   plot_concentrations(states, concentrations_per_m3(:, 1 : end - 2));
%   plot_boltzmann_rmse(states, concentrations_per_m3(:, 1 : end - 2), temp_k, time_s);
%   plot_total_conservation(time_s, concentrations_per_m3);

%   plot_concentrations_vs_time(figure_ids(2), style, x_lims, time_s, O3_total_per_m3);
%   plot_concentrations_vs_time(figure_ids(1), style1, time_s, O_concentration_per_m3);
%   plot_concentrations_vs_time(figure_ids(1), 'g.-', time_s, O2_concentration_per_m3);

%   plot_concentrations_vs_time(10, 'b.-', time_s, O_concentration_per_m3 .* O2_concentration_per_m3);
%   plot_displacements_vs_time(figure_ids(2), style1, x_lims, time_s, O3_bound_displacement_per_m3);

%   plot_derivatives_vs_time(figure_ids(3), style1, x_lims, time_s, dO3dt_total_per_m3_s);
  plot_krec_vs_time(figure_ids(4), style, x_lims, time_s, krec_m6_per_s);
end