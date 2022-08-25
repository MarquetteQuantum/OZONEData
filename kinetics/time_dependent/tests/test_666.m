function test_666()
  resonances = getvar('resonances');
  j_per_cm_1 = getvar('j_per_cm_1');
  m_per_a0 = getvar('m_per_a0');
  
  o3_molecule = '666';
  Js = 24;
  Ks = 2;
  syms = 0;
  temp_k = 298;
  M_per_m3 = 6.44e24;
  dE_j = [-43.13, nan] * j_per_cm_1;
  dE_j(2) = get_dE_up(dE_j(1), temp_k);
  sigma0_tran_m2 = 1500 * m_per_a0^2;
  time_s = linspace(0, 20e-9, 51);
  transition_model = {{'sym'}};
  name_666 = "sym";
  optional = map_create();
  optional('k_dependent_threshold') = 0;

  key = get_key(o3_molecule, Js, Ks, syms);
  states = resonances(key);
  states = states(states{:, 'energy'} > -3000 * j_per_cm_1, :);
  states = states(states{:, 'energy'} < 300 * j_per_cm_1, :);
  states = assign_extra_properties(o3_molecule, states);

  initial_concentrations_per_m3 = zeros(size(states, 1) + 2, 1);
  initial_concentrations_per_m3(end - 1) = 6.44e18; % [6]
  initial_concentrations_per_m3(end) = 6.44e20; % [66]

  tic
  [concentrations_666_per_m3, derivatives_666_per_m3_s, equilibrium_constants_666_m3] = ...
    propagate_concentrations_666(o3_molecule, states, initial_concentrations_per_m3, time_s, sigma0_tran_m2, ...
    temp_k, M_per_m3, dE_j, transition_model, name_666, optional);
  toc

  Keq_m3 = sum(equilibrium_constants_666_m3);
  O3_per_m3 = sum(concentrations_666_per_m3(:, 1 : end - 2), 2);
  dO3dt_per_m3_s = sum(derivatives_666_per_m3_s(:, 1 : end - 2), 2);
  O6_per_m3 = concentrations_666_per_m3(:, end - 1);
  O66_per_m3 = concentrations_666_per_m3(:, end);
  krec_666_m6_per_s = dO3dt_per_m3_s ./ (O6_per_m3 .* O66_per_m3 - O3_per_m3 / Keq_m3) / M_per_m3;

  x_lim = [time_s(3), time_s(end)] * 1e9;
  my_plot(time_s * 1e9, krec_666_m6_per_s, "Time, ns", "k_{rec}, m^6/s", xlim=x_lim);
end