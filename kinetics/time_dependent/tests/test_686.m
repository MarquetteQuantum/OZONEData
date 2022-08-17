function test_686()
  resonances = getvar('resonances');
  j_per_cm_1 = getvar('j_per_cm_1');
  m_per_a0 = getvar('m_per_a0');
  
  o3_molecule = '686';
  Js = 24;
  Ks = 2;
  syms = 0;
  temp_k = 298;
  M_per_m3 = 6.44e24;
  dE_j = [-43.13, nan] * j_per_cm_1;
  dE_j(2) = get_dE_up(dE_j(1), temp_k);
  sigma0_tran_m2 = 1500 * m_per_a0^2;
  time_s = linspace(0, 100e-9, 101);
  optional = map_create();
  optional('k_dependent_threshold') = 0;
  optional('transition_model') = {{'sym'}, {'asym'}, {'vdw_a_sym', 'vdw_a_asym'}, {'vdw_b'}};
%   optional('transition_model') = {{'sym', 'asym'}, {'vdw_a_sym', 'vdw_a_asym', 'vdw_b'}};

  key = get_key(o3_molecule, Js, Ks, syms);
  states = resonances(key);
  states = states(states{:, 'energy'} > -3000 * j_per_cm_1, :);
  states = states(states{:, 'energy'} < 300 * j_per_cm_1, :);
  states = assign_extra_properties(o3_molecule, states);

  initial_concentrations_per_m3 = zeros(size(states, 1) + 4, 1);
  initial_concentrations_per_m3(end - 3) = 3.22e18; % [8]
  initial_concentrations_per_m3(end - 2) = 3.22e20; % [66]
  initial_concentrations_per_m3(end - 1) = 6.44e18; % [6]
  initial_concentrations_per_m3(end) = 6.44e20; % [68]

  tic
  [concentrations_per_m3, ode_func, ~, Keqs_m3] = propagate_concentrations(2, o3_molecule, states, ...
    initial_concentrations_per_m3, time_s, sigma0_tran_m2, temp_k, M_per_m3, dE_j, optional);
  toc

  O6_per_m3 = concentrations_per_m3(:, end - 1);
  O68_per_m3 = concentrations_per_m3(:, end);
  O3_sym_per_m3 = sum(concentrations_per_m3(:, 1 : end - 4) .* states{:, "sym_mol"}', 2);
  O3_asym_per_m3 = sum(concentrations_per_m3(:, 1 : end - 4) .* states{:, "asym_mol"}', 2);
  eta = O3_asym_per_m3 ./ O3_sym_per_m3 / 2;

  dO3dt_per_m3_s = row_function(@(row) ode_func(0, row')', concentrations_per_m3);
  dO3dt_sym_per_m3_s = sum(dO3dt_per_m3_s(:, 1 : end - 4) .* states{:, "sym_mol"}', 2);
  dO3dt_asym_per_m3_s = sum(dO3dt_per_m3_s(:, 1 : end - 4) .* states{:, "asym_mol"}', 2);
  Keq2_sym_m3 = sum(Keqs_m3(:, 2) .* states{:, "sym_mol"});
  Keq2_asym_m3 = sum(Keqs_m3(:, 2) .* states{:, "asym_mol"});
  krec_sym_m6_per_s = dO3dt_sym_per_m3_s ./ (O6_per_m3 .* O68_per_m3 - O3_sym_per_m3 / Keq2_sym_m3) / M_per_m3;
  krec_asym_m6_per_s = dO3dt_asym_per_m3_s ./ (O6_per_m3 .* O68_per_m3 - O3_asym_per_m3 / Keq2_asym_m3) / M_per_m3;
  eta_krec = krec_asym_m6_per_s ./ krec_sym_m6_per_s / 2;

  eta_keq = sum(Keq2_asym_m3) / sum(Keq2_sym_m3) / 2;

  x_lim = [time_s(3), time_s(end)] * 1e9;
  my_plot(time_s * 1e9, O3_sym_per_m3, "Time, ns", "[O_3], m^{-3}", xlim=x_lim);
  my_plot(time_s * 1e9, O3_asym_per_m3, new_plot=false, color="r");
  my_plot(time_s * 1e9, krec_sym_m6_per_s, "Time, ns", "k_{rec}, m^6/s", xlim=x_lim);
  my_plot(time_s * 1e9, krec_asym_m6_per_s, new_plot=false, color="r");
  my_plot(time_s * 1e9, eta, "Time, ns", "\eta", xlim=x_lim);
  my_plot(time_s * 1e9, eta_krec, new_plot=false, color="r");
end