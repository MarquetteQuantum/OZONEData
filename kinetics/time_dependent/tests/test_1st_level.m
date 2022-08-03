function test_1st_level()
% Tests the first level of time dependent theory (transitions only, no formation/decay)
  resonances = getvar('resonances');
  j_per_cm_1 = getvar('j_per_cm_1');
  m_per_a0 = getvar('m_per_a0');
  
  o3_molecule = '666';
  Js = 0;
  Ks = 0;
  syms = 0;
  temp_k = 298;
  m_conc_per_m3 = 6.44e24;
  dE_j = [-43.13, nan] * j_per_cm_1;
  dE_j(2) = get_dE_up(dE_j(1), temp_k);
  sigma0_tran_m2 = 250 * m_per_a0^2;
  time_s = linspace(0, 100e-9, 101);

  key = get_key(o3_molecule, Js, Ks, syms);
  states = resonances(key);
  states = states(states{:, 'energy'} > -100 * j_per_cm_1, :);
  states = states(states{:, 'energy'} < 100 * j_per_cm_1, :);
  first_unbound = find(states{:, 'energy'} > 0, 1);

  initial_concentrations_per_m3 = zeros(size(states, 1), 1);
%   initial_concentrations_per_m3(end) = 1;
%   initial_concentrations_per_m3(first_unbound) = 1;
  initial_concentrations_per_m3(first_unbound:end) = 1 / (size(states, 1) - first_unbound + 1);

  [concentrations_per_m3, deriv_func] = propagate_concentrations(1, o3_molecule, states, ...
    initial_concentrations_per_m3, time_s, sigma0_tran_m2, temp_k, m_conc_per_m3, dE_j);

  bound_concentration_per_m3 = sum(concentrations_per_m3(:, 1:first_unbound - 1), 2);
  unbound_concentration_per_m3 = sum(concentrations_per_m3(:, first_unbound:end), 2);
  bound_displacement_per_m3 = bound_concentration_per_m3 - bound_concentration_per_m3(end);
  unbound_displacement_per_m3 = unbound_concentration_per_m3 - unbound_concentration_per_m3(end);

  do3dt_per_m3_s = row_function(@(row) get_nth(deriv_func(row'), 1)', concentrations_per_m3);
%   do3dt_per_m3_s = gradient(concentrations_per_m3, time_s(2) - time_s(1));
  do3dt_bound_per_m3_s = sum(do3dt_per_m3_s(:, 1:first_unbound-1), 2);
  do3dt_unbound_per_m3_s = sum(do3dt_per_m3_s(:, first_unbound:end), 2);
  krec_per_s = do3dt_bound_per_m3_s ./ unbound_displacement_per_m3;

  influx_bound_per_m3_s = row_function(@(row) get_nth(deriv_func(row'), 2)', concentrations_per_m3);
  influx_unbound_per_m3_s = row_function(@(row) get_nth(deriv_func(row'), 3)', concentrations_per_m3);
  flux_unbound_bound_per_m3_s = sum(influx_unbound_per_m3_s(:, 1 : first_unbound - 1), 2);
  flux_bound_unbound_per_m3_s = sum(influx_bound_per_m3_s(:, first_unbound : end), 2);

  krec_bound_per_s = flux_unbound_bound_per_m3_s ./ unbound_concentration_per_m3;
  krec_unbound_per_s = flux_bound_unbound_per_m3_s ./ bound_concentration_per_m3;

  figure_ids = 1:10;
%   figure_ids = zeros(1, 10);
  figure_ids = ones(1, 10)*10;
%   figure_ids = 5:8;
  style1 = 'b.-';
  style2 = 'b.--';
%   styles = {'b.-', 'r.-', 'g.-', 'b.--', 'r.--', 'g.--'};
%   style_id = 1;

%   plot_concentrations(states, concentrations_per_m3);
%   plot_boltzmann_rmse(states, concentrations_per_m3, temp_k, time_s);
%   plot_total_conservation(time_s, concentrations_per_m3);

%   plot_bound_unbound_concentrations(figure_ids(1), style1, style2, ...
%     time_s, bound_concentration_per_m3, unbound_concentration_per_m3);
%   plot_bound_unbound_displacements(figure_ids(2), style1, style2, ...
%     time_s, bound_displacement_per_m3, unbound_displacement_per_m3);
%   plot_bound_unbound_derivatives(figure_ids(3), style1, style2, ...
%     time_s, do3dt_bound_per_m3_s, do3dt_unbound_per_m3_s);
%   plot_krec_vs_time(figure_ids(4), style1, time_s, krec_per_s);

%   plot_bound_unbound_flux(figure_ids(5), style1, style2, ...
%     time_s, flux_unbound_bound_per_m3_s, flux_bound_unbound_per_m3_s);
  plot_krec_vs_time_flux(figure_ids(6), style1, style2, time_s, krec_bound_per_s, krec_unbound_per_s);
end