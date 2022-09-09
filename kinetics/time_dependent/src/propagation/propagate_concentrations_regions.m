function [concentrations_per_m3, derivatives_per_m3_s, equilibrium_constants_m3] = propagate_concentrations_regions(...
  o3_molecule, states, initial_concentrations_per_m3, time_s, sigma0_m2, temp_k, M_conc_per_m3, dE_j, ...
  transition_models, region_names, optional)
% Propagates concentrations for sym and asym molecules
% Return values dimensions for concentrations and derivatives: 1st - time, 2nd - states, 3rd - regions
% Return values dimensions for equilibrium_constants: 1st - states, 2nd - channels, 3rd - regions
% region_names consist of 1 (666) or 2 (686) elements
% transition_model should include 2 elements for separate_propagation is true, otherwise 1
% region_names specifies names of the columns in states table to be used as sym/asym separation multipliers

  if nargin < nargin(@propagate_concentrations_regions)
    optional = nan;
  end
  separate_propagation = get_or_default(optional, 'separate_propagation', false);

  equilibrium_constants_total_m3 = calculate_formation_decay_equilibrium_2(o3_molecule, states, temp_k, optional);
  equilibrium_constants_m3 = zeros([size(equilibrium_constants_total_m3), length(region_names)]);
  for i = 1:length(region_names)
    equilibrium_constants_m3(:, :, i) = equilibrium_constants_total_m3 .* states{:, region_names(i)};
  end
  
  if ~separate_propagation
    [concentrations_total_per_m3, derivatives_total_per_m3_s] = propagate_concentrations(o3_molecule, states, ...
      initial_concentrations_per_m3, equilibrium_constants_total_m3, time_s, sigma0_m2, temp_k, M_conc_per_m3, ...
      dE_j, transition_models{1}, optional);

    last_o3_ind = size(states, 1);
    concentrations_per_m3 = repmat(concentrations_total_per_m3, [1, 1, length(region_names)]);
    derivatives_per_m3_s = repmat(derivatives_total_per_m3_s, [1, 1, length(region_names)]);
    for i = 1:length(region_names)
      concentrations_per_m3(:, 1:last_o3_ind, i) = ...
        concentrations_per_m3(:, 1:last_o3_ind, i) .* states{:, region_names(i)}';
      derivatives_per_m3_s(:, 1:last_o3_ind, i) = ...
        derivatives_per_m3_s(:, 1:last_o3_ind, i) .* states{:, region_names(i)}';
    end
  else
    [concentrations_sym_per_m3, derivatives_sym_per_m3_s] = propagate_concentrations(o3_molecule, states, ...
      initial_concentrations_per_m3, equilibrium_constants_m3(:, :, 1), time_s, sigma0_m2, temp_k, M_conc_per_m3, ...
      dE_j, transition_models{1}, optional);
    [concentrations_asym_per_m3, derivatives_asym_per_m3_s] = propagate_concentrations(o3_molecule, states, ...
      initial_concentrations_per_m3, equilibrium_constants_m3(:, :, 2), time_s, sigma0_m2, temp_k, M_conc_per_m3, ...
      dE_j, transition_models{2}, optional);
    concentrations_per_m3 = cat(3, concentrations_sym_per_m3, concentrations_asym_per_m3);
    derivatives_per_m3_s = cat(3, derivatives_sym_per_m3_s, derivatives_asym_per_m3_s);
  end
end