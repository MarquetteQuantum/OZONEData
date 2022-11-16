function [krecs_m6_per_s, eval_times_s] = propagate_concentrations_2(o3_molecule, states, ...
  initial_concentrations_per_m3, time_s, sigma0_m2, temp_k, M_conc_per_m3, dE_j, region_names, optional)
% Propagates concentrations for sym and asym molecules
% Return dimensions for concentrations and derivatives: 1st - time, 2nd - states, 3rd - regions
% Return dimensions for equilibrium_constants: 1st - states, 2nd - channels, 3rd - regions
% transition_model should include 2 elements for separate_propagation is true, otherwise 1
% region_names specifies names of the columns in states table to be used as sym/asym separation multipliers
  arguments
    o3_molecule
    states
    initial_concentrations_per_m3
    time_s
    sigma0_m2
    temp_k
    M_conc_per_m3
    dE_j
    region_names
    optional.K_dependent_threshold = false
    optional.separate_concentrations = false
    optional.alpha0 = 0
    optional.region_factors = ones(size(region_names))
  end

  equilibrium_constants_m3 = calculate_formation_decay_equilibrium_2(o3_molecule, states, temp_k, ...
    K_dependent_threshold=optional.K_dependent_threshold);
  decay_coeffs_per_s = get_decay_coeffs_2(o3_molecule, states, K_dependent_threshold=optional.K_dependent_threshold);
  [krecs_m6_per_s, eval_times_s] = propagate_concentrations(o3_molecule, states, initial_concentrations_per_m3, ...
    equilibrium_constants_m3, decay_coeffs_per_s, time_s, sigma0_m2, temp_k, M_conc_per_m3, dE_j, region_names, ...
    separate_concentrations=optional.separate_concentrations, alpha0=optional.alpha0, ...
    region_factors=optional.region_factors);
end