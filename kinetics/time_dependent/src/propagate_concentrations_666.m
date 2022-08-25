function [concentrations_666_per_m3, derivatives_666_per_m3_s, equilibrium_constants_666_m3] = ...
  propagate_concentrations_666(o3_molecule, states, initial_concentrations_per_m3, time_s, sigma0_m2, temp_k, ...
  M_conc_per_m3, dE_j, transition_model_666, name_666, optional)
% 666 wrapper for concentrations propagation
% name_666 specifies name of the columns in states table to be used as the corresponding probabilities

  if nargin < nargin(@propagate_concentrations_666)
    optional = nan;
  end

  equilibrium_constants_total_m3 = calculate_formation_decay_equilibrium_2(o3_molecule, states, temp_k, optional);
  equilibrium_constants_666_m3 = equilibrium_constants_total_m3 .* states{:, name_666};
  [concentrations_total_per_m3, derivatives_total_per_m3_s] = propagate_concentrations(o3_molecule, states, ...
    initial_concentrations_per_m3, equilibrium_constants_total_m3, time_s, sigma0_m2, temp_k, M_conc_per_m3, ...
    dE_j, transition_model_666, optional);
  mult_666 = [states{:, name_666}', 1, 1];
  concentrations_666_per_m3 = concentrations_total_per_m3 .* mult_666;
  derivatives_666_per_m3_s = derivatives_total_per_m3_s .* mult_666;
end