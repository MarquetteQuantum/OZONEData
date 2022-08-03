function plot_krec_vs_pressure()
  resonances = getvar('resonances');
  j_per_cm_1 = getvar('j_per_cm_1');
  m_per_a0 = getvar('m_per_a0');
  
  o3_molecule = '666';
  Js = 24;
  Ks = 2;
  syms = 0;
  temp_k = 298;
  M_per_m3 = 6.44 * logspace(22, 32, 11);
  dE_j = [-43.13, nan] * j_per_cm_1;
  dE_j(2) = get_dE_up(dE_j(1), temp_k);
  sigma0_m2 = 250 * m_per_a0^2;
  optional = map_create();
  optional('k_dependent_threshold') = 0;

  key = get_key(o3_molecule, Js, Ks, syms);
  states = resonances(key);
  states = states(states{:, 'energy'} > -3000 * j_per_cm_1, :);
  states = states(states{:, 'energy'} < 300 * j_per_cm_1, :);
%   states = states(states{:, 'gamma_total'} < 1 * j_per_cm_1, :);
  states = assign_extra_properties(o3_molecule, states);

  krecs_m6_per_s = arrayfun(@(M) find_krec_eig(o3_molecule, temp_k, sigma0_m2, states, dE_j, M, optional), M_per_m3);
  
  experimental = get_krec_vs_pressure_experimental_666();
  krec_exp_m6_per_s = experimental(:, 2) * 1e-12;
  pressure = m_conc_to_bar(M_per_m3, temp_k);
  create_x_log_plot();
  plot(pressure, krecs_m6_per_s, 'b.-', 'MarkerSize', 10);
  yyaxis right
  plot(experimental(:, 1), krec_exp_m6_per_s, 'k.', 'MarkerSize', 20);
  xlabel('Pressure, bar');
  ylabel('krec, m^6/s');
end