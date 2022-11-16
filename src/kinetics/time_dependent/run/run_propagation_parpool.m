function run_propagation_parpool()
  j_per_cm = get_j_per_cm();
  m_per_a0 = get_m_per_a0();
  ref_pressure_per_m3 = 6.44e24;
  ch1_concs_per_m3 = [6.44e18, 6.44e20];
  base_time_s = linspace(0, 10000e-9, 5001);
  
  o3_molecules = {'686'};
  Js = [0:32, 36:4:40];
  Ks = 0:19;
  vib_syms_well = 0:1;
  energy_range_j = [-3000, 300] * j_per_cm;
  gamma_range_j = [1, inf] * j_per_cm;

  temp_k = 298;
  M_concs_per_m3 = 6.44 * logspace(23, 28, 6);
  dE_j = [-43.13, nan] * j_per_cm;
  dE_j(2) = get_dE_up(dE_j(1), temp_k);
  sigma0_tran_m2 = 2000 * m_per_a0^2;
  region_names = ["sym", "asym"];
  
  K_dependent_threshold = false;
  separate_concentrations = true;
  alpha0 = 0;
  region_factors = [1, 2];

  closed_channel = "";
  localization_threshold = 1e-3;

  save("env.mat");
  if isfile("krecs.mat")
    load("krecs.mat");
    remaining_inds = find(propagation_times == 0);
  else
    krecs_m6_per_s = zeros(length(M_concs_per_m3), length(o3_molecules), length(Ks), length(Js), ...
      length(vib_syms_well), length(region_names));
    propagation_times = ...
      zeros(length(M_concs_per_m3), length(o3_molecules), length(Ks), length(Js), length(vib_syms_well));
    execution_times = ...
      zeros(length(M_concs_per_m3), length(o3_molecules), length(Ks), length(Js), length(vib_syms_well));
    remaining_inds = 1:numel(propagation_times);
  end
  
  home_path = getenv("HOME");
  resonances_prefix = [fullfile(home_path, 'ozone_kinetics', 'data', 'resonances'), filesep];
  barriers_prefix = [fullfile(home_path, 'ozone_kinetics', 'data', 'barriers'), filesep];

  data_queue = parallel.pool.DataQueue;
  data_queue.afterEach(@data_handler);
  parpool('local', 128);
  tic
  parfor ind_ind = 1:length(remaining_inds)
    data_ind = remaining_inds(ind_ind);
    [M_ind, o3_ind, K_ind, J_ind, sym_ind] = ind2sub(size(propagation_times), data_ind);
    [M_per_m3, o3_molecule, K, J, vib_sym_well] = ...
      deal(M_concs_per_m3(M_ind), o3_molecules{o3_ind}, Ks(K_ind), Js(J_ind), vib_syms_well(sym_ind));
    
    if K > J || J > 32 && mod(K, 2) == 1
      continue
    end

    data_key = get_key_vib_well(o3_molecule, J, K, vib_sym_well);
    resonances_format = iif(o3_molecule == "868", "686", o3_molecule);
    states = read_resonances(fullfile(resonances_prefix, data_key), resonances_format, delim=resonances_prefix);
    states = states(data_key);
    states = process_states(barriers_prefix, o3_molecule, states, energy_range_j, gamma_range_j, ...
      closed_channel=closed_channel, localization_threshold=localization_threshold);

    initial_concentrations_per_m3 = get_initial_concentrations(ch1_concs_per_m3, o3_molecule, states, temp_k, ...
      K_dependent_threshold=K_dependent_threshold, separate_concentrations=separate_concentrations, ...
      region_names=region_names);
    pressure_ratio = M_per_m3 / ref_pressure_per_m3;
    time_s = base_time_s / pressure_ratio;

    tic
    next_krecs_m6_per_s = propagate_concentrations_2(o3_molecule, states, initial_concentrations_per_m3, time_s, ...
      sigma0_tran_m2, temp_k, M_per_m3, dE_j, region_names, K_dependent_threshold=K_dependent_threshold, ...
      separate_concentrations=separate_concentrations, alpha0=alpha0, region_factors=region_factors);
    execution_time = toc;
    propagation_time_s = time_s(size(next_krecs_m6_per_s, 2));
    send(data_queue, ...
      [M_ind, o3_ind, K_ind, J_ind, sym_ind, propagation_time_s, execution_time, next_krecs_m6_per_s(:, end)']);
  end
  toc

  function data_handler(data)
    propagation_times(data(1), data(2), data(3), data(4), data(5)) = data(6);
    execution_times(data(1), data(2), data(3), data(4), data(5)) = data(7);
    krecs_m6_per_s(data(1), data(2), data(3), data(4), data(5), :) = data(8:end);
    save("krecs.mat", "propagation_times", "execution_times", "krecs_m6_per_s");
  end
end