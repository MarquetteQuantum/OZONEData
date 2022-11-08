function krecs_m6_per_s = propagate_concentrations(o3_molecule, states, initial_concentrations_per_m3, ...
  equilibrium_constants_m3, decay_coeffs_per_s, time_s, sigma0_m2, temp_k, M_conc_per_m3, dE_j, region_names, optional)
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
    optional.separate_concentrations = false
    optional.transition_model = {}
    optional.alpha0 = 0
  end

  if ~optional.separate_concentrations
    assert(~isempty(optional.transition_model), ...
      "Transition model has to be specified if separate_concentrations is false");
    transition_matrix_m3_per_s = calculate_transition_matrix_unitless(states, dE_j, optional.transition_model);
  else
    transition_matrix_m3_per_s = ...
      calculate_transition_matrix_unitless_separate(states, dE_j, region_names, optional.alpha0);
    decay_coeffs_per_s = repmat(decay_coeffs_per_s, [length(region_names), 1]);
    equilibrium_constants_m3 = ...
      column_function(@(col) reshape(states{:, region_names} .* col, [], 1), equilibrium_constants_m3); 
  end

  k0_tran_m3_per_s = get_k0_2(o3_molecule, temp_k, sigma0_m2);
  transition_matrix_m3_per_s = transition_matrix_m3_per_s * k0_tran_m3_per_s * M_conc_per_m3;
  transition_matrix_m3_per_s = (transition_matrix_m3_per_s - diag(sum(transition_matrix_m3_per_s, 2)))';
  ode_func = @(t, y) do3dt(transition_matrix_m3_per_s, decay_coeffs_per_s, equilibrium_constants_m3, y);

  % krec is calculated wrt the lowest channel of the first region
  channel_ind = get_lower_channel_ind(o3_molecule);
  eval_step_s = time_s(2) - time_s(1);
  [event_func, krec_return] = get_ode_event_handler(ode_func, sum(equilibrium_constants_m3, 1), channel_ind, ...
    M_conc_per_m3, eval_step_s, states{:, region_names}, separate_concentrations=optional.separate_concentrations);

  options = odeset('RelTol', 1e-13, 'AbsTol', 1e-15, 'Events', event_func);
  [~, ~, ~, ~, ~] = ode89(ode_func, time_s, initial_concentrations_per_m3, options);
  krecs_m6_per_s = krec_return();
end