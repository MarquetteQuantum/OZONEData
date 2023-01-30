function propagation_parallel_job(ref_pressure_per_m3, base_time_s, ch1_concs_per_m3, o3_molecule, Js, Ks, vib_syms_well, energy_range_j, gamma_range_j, ...
  temps_k, M_concs_per_m3, dE_down_j, sigma_tran_m2, region_names, require_convergence, optional)
  arguments
    ref_pressure_per_m3
    base_time_s
    ch1_concs_per_m3
    o3_molecule
    Js
    Ks
    vib_syms_well
    energy_range_j
    gamma_range_j
    temps_k
    M_concs_per_m3
    dE_down_j
    sigma_tran_m2
    region_names
    require_convergence
    optional.K_dependent_threshold = false
    optional.separate_concentrations = false
    optional.alpha0 = 0
    optional.region_factors = ones(size(region_names))
    optional.formation_mult = 1
    optional.decay_mult = 1
    optional.closed_channel = ""
    optional.localization_threshold = 1e-3
    optional.gamma_use_reference = false
    optional.new_db = true
    optional.save_time = true
  end

  save("env.mat");
  if isfile("krecs.mat")
    load("krecs.mat");
    remaining_inds = find(execution_times == 0);
  else
    if ~optional.save_time
      krecs_m6_per_s = zeros(length(M_concs_per_m3), length(temps_k), length(Ks), length(Js), length(vib_syms_well), length(region_names));
    else
      krecs_m6_per_s = cell(length(M_concs_per_m3), length(temps_k), length(Ks), length(Js), length(vib_syms_well), length(region_names));
    end
    propagation_times_s = zeros(length(M_concs_per_m3), length(temps_k), length(Ks), length(Js), length(vib_syms_well));
    execution_times = zeros(length(M_concs_per_m3), length(temps_k), length(Ks), length(Js), length(vib_syms_well));
    remaining_inds = 1:numel(execution_times);
  end
  
  home_path = getenv("HOME");
  resonances_prefix = [fullfile(home_path, 'ozone_kinetics', 'data', 'resonances'), filesep];
  barriers_prefix = [fullfile(home_path, 'ozone_kinetics', 'data', 'barriers'), filesep];
  resonances_format = iif(is_monoisotopic(o3_molecule), "666", "686");

  data_queue = parallel.pool.DataQueue;
  data_queue.afterEach(@data_handler);
  tic
  parfor ind_ind = 1:length(remaining_inds)
    [M_ind, temp_ind, K_ind, J_ind, sym_ind] = ind2sub(size(execution_times), remaining_inds(ind_ind));
    [M_per_m3, temp_k, K, J, vib_sym_well] = deal(M_concs_per_m3(M_ind), temps_k(temp_ind), Ks(K_ind), Js(J_ind), vib_syms_well(sym_ind));
    dE_up_j = get_dE_up(dE_down_j, temp_k);
    
    if K > J || ~optional.new_db && J > 32 && mod(K, 2) == 1
      continue
    end

    data_key = get_key_vib_well(o3_molecule, J, K, vib_sym_well);
    states = read_resonances(fullfile(resonances_prefix, data_key), resonances_format, delim=resonances_prefix);
    states = states(data_key);
    states = process_states(barriers_prefix, o3_molecule, states, energy_range_j, gamma_range_j, closed_channel=optional.closed_channel, ...
      localization_threshold=optional.localization_threshold, gamma_use_reference=optional.gamma_use_reference);

    initial_concentrations_per_m3 = get_initial_concentrations(ch1_concs_per_m3, o3_molecule, states, temp_k, ...
      K_dependent_threshold=optional.K_dependent_threshold, separate_concentrations=optional.separate_concentrations, region_names=region_names);
    pressure_ratio = M_per_m3 / ref_pressure_per_m3;
    time_s = base_time_s / pressure_ratio;

    tic
    [next_krecs_m6_per_s, eval_times_s] = propagate_concentrations_2(o3_molecule, states, initial_concentrations_per_m3, time_s, sigma_tran_m2, temp_k, ...
      M_per_m3, [dE_down_j, dE_up_j], region_names, require_convergence, K_dependent_threshold=optional.K_dependent_threshold, ...
      separate_concentrations=optional.separate_concentrations, alpha0=optional.alpha0, region_factors=optional.region_factors, ...
      formation_mult=optional.formation_mult, decay_mult=optional.decay_mult);
    execution_time = toc;

    propagation_time_s = eval_times_s{1}(end);
    if ~optional.save_time
      next_krecs_m6_per_s = cellfun(@(x) x(end), next_krecs_m6_per_s);
      send(data_queue, [M_ind, temp_ind, K_ind, J_ind, sym_ind, propagation_time_s, execution_time, next_krecs_m6_per_s']);
    else
      send(data_queue, {M_ind, temp_ind, K_ind, J_ind, sym_ind, propagation_time_s, execution_time, next_krecs_m6_per_s});
    end
  end
  toc

  function data_handler(data)
    if ~optional.save_time
      propagation_times_s(data(1), data(2), data(3), data(4), data(5)) = data(6);
      execution_times(data(1), data(2), data(3), data(4), data(5)) = data(7);
      krecs_m6_per_s(data(1), data(2), data(3), data(4), data(5), :) = data(8:end);
    else
      propagation_times_s(data{1}, data{2}, data{3}, data{4}, data{5}) = data{6};
      execution_times(data{1}, data{2}, data{3}, data{4}, data{5}) = data{7};
      krecs_m6_per_s(data{1}, data{2}, data{3}, data{4}, data{5}, :) = data{8};
    end
    save("krecs.mat", "propagation_times_s", "execution_times", "krecs_m6_per_s");
  end
end