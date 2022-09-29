function test_propagation_parallel()
  j_per_cm = get_j_per_cm();
  m_per_a0 = get_m_per_a0();
  ref_pressure_per_m3 = 6.44e24;
  
  o3_molecules = {'666'};
  Js = [0:32, 36:4:64];
  Ks = 0:20;
  vib_syms_well = 0:1;
  temp_k = 298;
  M_concs_per_m3 = 6.44 * logspace(23, 28, 6);
  dE_j = [-43.13, nan] * j_per_cm;
  dE_j(2) = get_dE_up(dE_j(1), temp_k);
  sigma0_tran_m2 = 1500 * m_per_a0^2;

%   transition_models = {{["cov"]}};
  transition_models = {{["sym"], ["asym"]}};
%   transition_models = {{["sym"]}, {["asym"]}};
  
  region_names = ["cov"];
%   region_names = ["sym", "asym"];

  K_dependent_threshold = false;
  separate_propagation = false;

  data_prefix = [fullfile('data', 'resonances'), filesep];
  krecs_m6_per_s = zeros(length(M_concs_per_m3), length(o3_molecules), length(Ks), length(Js), length(vib_syms_well));
  krecs_vector = zeros(numel(krecs_m6_per_s), 1);
  tic
  for data_ind = 1:length(krecs_vector)
    [M_ind, o3_ind, K_ind, J_ind, sym_ind] = ind2sub(size(krecs_m6_per_s), data_ind);
    [M_per_m3, o3_molecule, K, J, vib_sym_well] = ...
      deal(M_concs_per_m3(M_ind), o3_molecules{o3_ind}, Ks(K_ind), Js(J_ind), vib_syms_well(sym_ind));
    if K > J || J > 32 && mod(K, 2) == 1
      continue
    end

    data_key = get_key_vib_well(o3_molecule, J, K, vib_sym_well);
    states = read_resonances(fullfile(data_prefix, data_key), o3_molecule, delim=data_prefix);
    states = states(data_key);
    states = process_states(o3_molecule, states);
    
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
  
    pressure_ratio = M_per_m3 / ref_pressure_per_m3;
    time_s = linspace(0, 100e-9, 51) / pressure_ratio;
    [concentrations_per_m3, derivatives_per_m3_s, equilibrium_constants_m3] = propagate_concentrations_regions(...
      o3_molecule, states, initial_concentrations_per_m3, time_s, sigma0_tran_m2, temp_k, M_per_m3, dE_j, ...
      transition_models, region_names, K_dependent_threshold=K_dependent_threshold, ...
      separate_propagation=separate_propagation);
  
    channel_ind = get_lower_channel_ind(o3_molecule);
    region_ind = 1;
    next_krec_m6_per_s = get_krec(concentrations_per_m3(:, :, region_ind), derivatives_per_m3_s(:, :, region_ind), ...
      equilibrium_constants_m3(:, :, region_ind), M_per_m3, channel_ind);
    krecs_vector(data_ind) = next_krec_m6_per_s(end);
  end
  toc
  
  krecs_m6_per_s = reshape(krecs_vector, size(krecs_m6_per_s));
  save("krecs.mat", "krecs_m6_per_s");
end