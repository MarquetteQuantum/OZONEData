function propagation_parallel_job(ref_pressure_per_m3, base_time_s, ch1_concs_per_m3, o3_molecules, Js, Ks, ...
  vib_syms_well, energy_range_j, gamma_range_j, temp_k, M_concs_per_m3, dE_j, sigma0_tran_m2, region_names, optional)
  arguments
    ref_pressure_per_m3
    base_time_s
    ch1_concs_per_m3
    o3_molecules
    Js
    Ks
    vib_syms_well
    energy_range_j
    gamma_range_j
    temp_k
    M_concs_per_m3
    dE_j
    sigma0_tran_m2
    region_names
    optional.K_dependent_threshold = false
    optional.separate_concentrations = false
    optional.transition_model = {}
    optional.alpha0 = 0
    optional.closed_channel = ""
    optional.localization_threshold = 1e-3
  end

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
  data_prefix = [fullfile(home_path, 'ozone_kinetics', 'data', 'resonances'), filesep];
  data_queue = parallel.pool.DataQueue;
  data_queue.afterEach(@data_handler);
  tic
  parfor ind_ind = 1:length(remaining_inds)
    [M_ind, o3_ind, K_ind, J_ind, sym_ind] = ind2sub(size(propagation_times), remaining_inds(ind_ind));
    [M_per_m3, o3_molecule, K, J, vib_sym_well] = ...
      deal(M_concs_per_m3(M_ind), o3_molecules{o3_ind}, Ks(K_ind), Js(J_ind), vib_syms_well(sym_ind));
    
    if K > J || J > 32 && mod(K, 2) == 1
      continue
    end

    data_key = get_key_vib_well(o3_molecule, J, K, vib_sym_well);
    states = read_resonances(fullfile(data_prefix, data_key), o3_molecule, delim=data_prefix);
    states = states(data_key);
    states = process_states(o3_molecule, states, energy_range_j, gamma_range_j, closed_channel=closed_channel, ...
      localization_threshold=localization_threshold);

    initial_concentrations_per_m3 = get_initial_concentrations(ch1_concs_per_m3, o3_molecule, states, temp_k, ...
      K_dependent_threshold=optional.K_dependent_threshold, ...
      separate_concentrations=optional.separate_concentrations, region_names=region_names);
    pressure_ratio = M_per_m3 / ref_pressure_per_m3;
    time_s = base_time_s / pressure_ratio;

    tic
    next_krecs_m6_per_s = propagate_concentrations_2(o3_molecule, states, initial_concentrations_per_m3, time_s, ...
      sigma0_tran_m2, temp_k, M_per_m3, dE_j, region_names, K_dependent_threshold=K_dependent_threshold, ...
      separate_concentrations=separate_concentrations, transition_model=transition_model, alpha0=optional.alpha0);
    execution_time = toc;
    propagation_time_s = time_s(size(next_krecs_m6_per_s, 2));
    send(data_queue, ...
      [M_ind, o3_ind, K_ind, J_ind, sym_ind, propagation_time_s, execution_time, next_krecs_m6_per_s(:, end)]);
  end
  toc

  function data_handler(data)
    propagation_times(data(1), data(2), data(3), data(4), data(5)) = data(6);
    execution_times(data(1), data(2), data(3), data(4), data(5)) = data(7);
    krecs_m6_per_s(data(1), data(2), data(3), data(4), data(5), :) = data(8:end);
    save("krecs.mat", "propagation_times", "execution_times", "krecs_m6_per_s");
  end
end