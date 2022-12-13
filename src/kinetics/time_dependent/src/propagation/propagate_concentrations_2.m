function [krecs_m6_per_s, eval_times_s] = propagate_concentrations_2(o3_molecule, states, initial_concentrations_per_m3, time_s, sigma0_m2, temp_k, ...
  M_conc_per_m3, dE_j, region_names, require_convergence, optional)
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
    require_convergence
    optional.K_dependent_threshold = false
    optional.separate_concentrations = false
    optional.alpha0 = 0
    optional.region_factors = ones(size(region_names))
    optional.equilibrium_mult = 1
  end

  equilibrium_constants_m3 = calculate_formation_decay_equilibrium_2(o3_molecule, states, temp_k, K_dependent_threshold=optional.K_dependent_threshold);
  equilibrium_constants_m3 = equilibrium_constants_m3 * optional.equilibrium_mult;
  decay_coeffs_per_s = get_decay_coeffs_2(o3_molecule, states, K_dependent_threshold=optional.K_dependent_threshold);

  if optional.separate_concentrations && length(optional.alpha0) == 1 && optional.alpha0 == 0
    % Propagate each block separately, assuming constant reactants concentration
    num_reactants = mod(length(initial_concentrations_per_m3), size(states, 1));
    reactant_concs_per_m3 = initial_concentrations_per_m3(end - num_reactants + 1 : end);
    krecs_m6_per_s = cell(length(region_names), 1);
    eval_times_s = cell(length(region_names), 1);
    for i = 1:length(region_names)
      state_concs_per_m3 = initial_concentrations_per_m3((i - 1) * size(states, 1) + 1 : i * size(states, 1));
      block_initial_concentrations_per_m3 = cat(1, state_concs_per_m3, reactant_concs_per_m3);
      [krecs_m6_per_s{i}, eval_times_s{i}] = propagate_concentrations(o3_molecule, states, block_initial_concentrations_per_m3, ...
        equilibrium_constants_m3, decay_coeffs_per_s, time_s, sigma0_m2, temp_k, M_conc_per_m3, dE_j, region_names(i), require_convergence(i), ...
        separate_concentrations=optional.separate_concentrations, alpha0=optional.alpha0, region_factors=optional.region_factors(i));
    end
  else
    [krecs_m6_per_s, eval_times_s] = propagate_concentrations(o3_molecule, states, initial_concentrations_per_m3, equilibrium_constants_m3, ...
      decay_coeffs_per_s, time_s, sigma0_m2, temp_k, M_conc_per_m3, dE_j, region_names, require_convergence, ...
      separate_concentrations=optional.separate_concentrations, alpha0=optional.alpha0, region_factors=optional.region_factors);
    krecs_m6_per_s = mat2cell(krecs_m6_per_s, ones(size(krecs_m6_per_s, 1), 1));
    eval_times_s = mat2cell(repmat(eval_times_s, [size(krecs_m6_per_s, 1), 1]), ones(size(krecs_m6_per_s, 1), 1));
  end
end