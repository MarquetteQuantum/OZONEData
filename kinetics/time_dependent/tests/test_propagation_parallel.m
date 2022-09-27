function test_propagation_parallel()
  resonances = getvar('resonances');
  j_per_cm = get_j_per_cm();
  m_per_a0 = get_m_per_a0();
  
  o3_molecule = '686';
  Js = 24;
  Ks = 0:3;
  vib_sym_well = 1;
  temp_k = 298;
  M_per_m3 = 6.44e24;
  dE_j = [-43.13, nan] * j_per_cm;
  dE_j(2) = get_dE_up(dE_j(1), temp_k);
  sigma0_tran_m2 = 1500 * m_per_a0^2;
  pressure_ratio = M_per_m3 / 6.44e24;
  time_s = linspace(0, 100e-9, 51) / pressure_ratio;

%   transition_models = {{["cov"]}};
  transition_models = {{["sym"], ["asym"]}};
%   transition_models = {{["sym"]}, {["asym"]}};
  
  region_names = ["cov"];
%   region_names = ["sym", "asym"];

  K_dependent_threshold = false;
  separate_propagation = false;

  krecs_m6_per_s = zeros(length(Ks), length(Js));
  data = cell(numel(krecs_m6_per_s), 1);
  for K_ind = 1:length(Ks)
    K = Ks(K_ind);
    for J_ind = 1:length(Js)
      J = Js(J_ind);
      if K > J || J > 32 && mod(K, 2) == 1
        continue
      end
      key = get_key_vib_well(o3_molecule, J, K, vib_sym_well);
      states = resonances(key);
      states = assign_extra_properties(o3_molecule, states);
      ref_energy_j = get_higher_barrier_threshold(o3_molecule, J, K, vib_sym_well);
      states = states(states{:, 'energy'} > ref_energy_j - 3000 * j_per_cm, :);
      states = states(states{:, 'energy'} < ref_energy_j + 300 * j_per_cm, :);

      data_ind = sub2ind(size(krecs_m6_per_s), K_ind, J_ind);
      data{data_ind} = states;
    end
  end

  krecs_vector = zeros(size(data));
  parfor data_ind = 1:length(data)
    states = data{data_ind};
    num_reactants = iif(is_monoisotopic(o3_molecule), 2, 4);
    initial_concentrations_per_m3 = zeros(size(states, 1) + num_reactants, 1);
    initial_concentrations_per_m3(size(states, 1) + 1) = 6.44e18; % ch1, reactant 1
    initial_concentrations_per_m3(size(states, 1) + 2) = 6.44e20; % ch1, reactant 2
    if num_reactants == 4
      Keqs_m3 = calculate_formation_decay_equilibrium_2(o3_molecule, states, temp_k, ...
        K_dependent_threshold=K_dependent_threshold);
      Kex = Keqs_m3(1, 2) / Keqs_m3(1, 1);
      % channel 2 is in equilibrium with channel 1
      initial_concentrations_per_m3(size(states, 1) + 3) = ...
        initial_concentrations_per_m3(size(states, 1) + 1) / sqrt(Kex);
      initial_concentrations_per_m3(size(states, 1) + 4) = ...
        initial_concentrations_per_m3(size(states, 1) + 2) / sqrt(Kex);
    end
  
    tic
    [concentrations_per_m3, derivatives_per_m3_s, equilibrium_constants_m3] = propagate_concentrations_regions(...
      o3_molecule, states, initial_concentrations_per_m3, time_s, sigma0_tran_m2, temp_k, M_per_m3, dE_j, ...
      transition_models, region_names, K_dependent_threshold=K_dependent_threshold, ...
      separate_propagation=separate_propagation);
    toc
  
    channel_ind = get_lower_channel_ind(o3_molecule);
    region_ind = 1;
    next_krec_m6_per_s = get_krec(concentrations_per_m3(:, :, region_ind), derivatives_per_m3_s(:, :, region_ind), ...
      equilibrium_constants_m3(:, :, region_ind), M_per_m3, channel_ind);
    krecs_vector(data_ind) = next_krec_m6_per_s(end);
  
    plot_time_ns = time_s(1 : length(next_krec_m6_per_s)) * 1e9;
    x_lim = [plot_time_ns(2), plot_time_ns(end)];
    my_plot(plot_time_ns, next_krec_m6_per_s, "Time, ns", "k_{rec}, m^6/s", xlim=x_lim);
  end
end