function [krecs_m6_per_s, eval_times_s] = propagate_concentrations(o3_molecule, states, initial_concentrations_per_m3, equilibrium_constants_m3, ...
  decay_coeffs_per_s, time_s, sigma0_m2, temp_k, M_conc_per_m3, dE_j, region_names, require_convergence, optional)
% Propagates states' concentrations. Assumes time_s is uniform.
  arguments
    o3_molecule
    states
    initial_concentrations_per_m3
    equilibrium_constants_m3
    decay_coeffs_per_s
    time_s
    sigma0_m2
    temp_k
    M_conc_per_m3
    dE_j
    region_names
    require_convergence
    optional.separate_concentrations = false
    optional.alpha0 = 0
    optional.region_factors = ones(size(region_names))
  end

  if ~optional.separate_concentrations
    transition_matrix_m3_per_s = calculate_transition_matrix_unitless(states, dE_j, region_names, region_factors=optional.region_factors);
  else
    transition_matrix_m3_per_s = calculate_transition_matrix_unitless_separate(states, dE_j, region_names, optional.alpha0, ...
      region_factors=optional.region_factors);
    decay_coeffs_per_s = repmat(decay_coeffs_per_s, [length(region_names), 1]);
    equilibrium_constants_m3 = column_function(@(col) reshape(states{:, region_names} .* col, [], 1), equilibrium_constants_m3);
  end

  k0_tran_m3_per_s = get_k0_2(o3_molecule, temp_k, sigma0_m2);
  transition_matrix_m3_per_s = transition_matrix_m3_per_s * k0_tran_m3_per_s * M_conc_per_m3;
  transition_matrix_m3_per_s = (transition_matrix_m3_per_s - diag(sum(transition_matrix_m3_per_s, 2)))';

  ode_func = @(t, y) do3dt(transition_matrix_m3_per_s, decay_coeffs_per_s, equilibrium_constants_m3, y);
  channel_ind = get_lower_channel_ind(o3_molecule);
  eval_step_s = time_s(2) - time_s(1);
  equilibrium_constants_total_m3 = sum(equilibrium_constants_m3, 1);
  event_func = get_ode_event_handler(eval_step_s, ode_func, M_conc_per_m3, equilibrium_constants_total_m3, channel_ind, states{:, region_names}, ...
    require_convergence, separate_concentrations=optional.separate_concentrations);

  options = odeset(RelTol=1e-10, AbsTol=1e-10, Events=event_func);
  [eval_times_s, concentrations_per_m3, ~, ~, ~] = ode45(ode_func, time_s, initial_concentrations_per_m3, options);
  eval_times_s = eval_times_s(1 : end-1)';
  concentrations_per_m3 = concentrations_per_m3(1 : end-1, :)';

  krecs_m6_per_s = column_function(@(concs) get_krec_regions(concs, ode_func, M_conc_per_m3, equilibrium_constants_total_m3, channel_ind, ...
    states{:, region_names}, separate_concentrations=optional.separate_concentrations), concentrations_per_m3);
end