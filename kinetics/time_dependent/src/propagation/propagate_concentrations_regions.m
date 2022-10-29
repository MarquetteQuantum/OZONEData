function [concentrations_per_m3, derivatives_per_m3_s, equilibrium_constants_m3] = propagate_concentrations_regions(...
  o3_molecule, states, initial_concentrations_per_m3, time_s, sigma0_m2, temp_k, M_conc_per_m3, dE_j, ...
  transition_models, region_names, optional)
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
    transition_models
    region_names
    optional.K_dependent_threshold = false
    optional.separate_propagation = false
  end

  equilibrium_constants_total_m3 = calculate_formation_decay_equilibrium_2(o3_molecule, states, temp_k, ...
    K_dependent_threshold=optional.K_dependent_threshold);
  equilibrium_constants_m3 = cell(length(region_names), 1);
  for i = 1:length(region_names)
    equilibrium_constants_m3{i} = equilibrium_constants_total_m3 .* states{:, region_names(i)};
  end
  decay_rates_per_s = get_decay_coeffs_2(o3_molecule, states, K_dependent_threshold=optional.K_dependent_threshold);

  if ~optional.separate_propagation
    [concentrations_total_per_m3, derivatives_total_per_m3_s] = propagate_concentrations(o3_molecule, states, ...
      initial_concentrations_per_m3, equilibrium_constants_total_m3, decay_rates_per_s, time_s, sigma0_m2, temp_k, ...
      M_conc_per_m3, dE_j, transition_models{1}, region_names);

    num_reactants = length(initial_concentrations_per_m3) - size(states, 1);
    concentrations_per_m3 = cell(length(region_names), 1);
    derivatives_per_m3_s = cell(length(region_names), 1);
    for i = 1:length(region_names)
      region_mults = [states{:, region_names(i)}', ones(1, num_reactants)];
      concentrations_per_m3{i} = concentrations_total_per_m3 .* region_mults;
      derivatives_per_m3_s{i} = derivatives_total_per_m3_s .* region_mults;
    end
    
  else
    [concentrations_sym_per_m3, derivatives_sym_per_m3_s] = propagate_concentrations(o3_molecule, states, ...
      initial_concentrations_per_m3, equilibrium_constants_m3{1}, decay_rates_per_s, time_s, sigma0_m2, ...
      temp_k, M_conc_per_m3, dE_j, transition_models{1}, region_names(1));
    [concentrations_asym_per_m3, derivatives_asym_per_m3_s] = propagate_concentrations(o3_molecule, states, ...
      initial_concentrations_per_m3, equilibrium_constants_m3{2}, decay_rates_per_s, time_s, sigma0_m2, ...
      temp_k, M_conc_per_m3, dE_j, transition_models{2}, region_names(2));
    concentrations_per_m3 = {concentrations_sym_per_m3, concentrations_asym_per_m3};
    derivatives_per_m3_s = {derivatives_sym_per_m3_s, derivatives_asym_per_m3_s};
  end
end