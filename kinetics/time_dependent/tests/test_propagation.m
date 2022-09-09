function test_propagation()
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
  time_s = linspace(0, 10e-9, 51);
  transition_models = {{["cov"]}};
%   transition_models = {{["sym"], ["asym"]}};
  region_names = "cov";
  optional = map_create();
  optional('k_dependent_threshold') = 0;
  optional('separate_propagation') = false;

  key = get_key(o3_molecule, Js, Ks, syms);
  states = resonances(key);
  barrier_energy = estimate_barrier_energy(states);
  states = states(states{:, 'energy'} > barrier_energy - 3000 * j_per_cm_1, :);
  states = states(states{:, 'energy'} < barrier_energy + 300 * j_per_cm_1, :);
  states = assign_extra_properties(o3_molecule, states);

  num_reactants = iif(is_monoisotopic(o3_molecule), 2, 4);
  initial_concentrations_per_m3 = zeros(size(states, 1) + num_reactants, 1);
  initial_concentrations_per_m3(size(states, 1) + 1) = 6.44e18; % ch1, reactant 1
  initial_concentrations_per_m3(size(states, 1) + 2) = 6.44e20; % ch1, reactant 2
  if num_reactants == 4
    Keqs_m3 = calculate_formation_decay_equilibrium_2(o3_molecule, states, temp_k, optional);
    Kex = Keqs_m3(1, 2) / Keqs_m3(1, 1);
    % channel 2 is in equilibrium with channel 1
    initial_concentrations_per_m3(size(states, 1) + 3) = initial_concentrations_per_m3(size(states, 1) + 1) / sqrt(Kex);
    initial_concentrations_per_m3(size(states, 1) + 4) = initial_concentrations_per_m3(size(states, 1) + 2) / sqrt(Kex);
  end

  tic
  [concentrations_per_m3, derivatives_per_m3_s, equilibrium_constants_m3] = ...
    propagate_concentrations_regions(o3_molecule, states, initial_concentrations_per_m3, time_s, sigma0_tran_m2, ...
    temp_k, M_per_m3, dE_j, transition_models, region_names, optional);
  toc

  ch = get_lower_channel_ind(o3_molecule);
  Keq_m3 = sum(equilibrium_constants_m3(:, ch, 1));
  O3_per_m3 = sum(concentrations_per_m3(:, 1 : end - num_reactants, 1), 2);
  dO3dt_per_m3_s = sum(derivatives_per_m3_s(:, 1 : end - num_reactants, 1), 2);
  reactants_per_m3 = concentrations_per_m3(:, end - 1 : end, 1);
  krec_m6_per_s = dO3dt_per_m3_s ./ (prod(reactants_per_m3, 2) - O3_per_m3 / Keq_m3) / M_per_m3;

  x_lim = [time_s(3), time_s(end)] * 1e9;
  my_plot(time_s * 1e9, krec_m6_per_s, "Time, ns", "k_{rec}, m^6/s", xlim=x_lim);
end