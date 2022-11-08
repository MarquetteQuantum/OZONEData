function plot_eta_vs_time()
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
  [concentrations_per_m3, ~, ~, ~] = propagate_concentrations(2, o3_molecule, states, ...
    initial_concentrations_per_m3, time_s, sigma0_tran_m2, temp_k, M_per_m3, dE_j, optional);
  toc

  O3_sym_per_m3 = sum(concentrations_per_m3(:, 1 : end - 4) .* states{:, "sym_mol"}', 2);
  O3_asym_per_m3 = sum(concentrations_per_m3(:, 1 : end - 4) .* states{:, "asym_mol"}', 2);
  eta = O3_asym_per_m3 ./ O3_sym_per_m3 / 2;

  my_plot(time_s * 1e9, eta, "Time, ns", "\eta");
end