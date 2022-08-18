function [concentrations_sym_per_m3, concentrations_asym_per_m3, derivatives_sym_per_m3_s, ...
  derivatives_asym_per_m3_s, equilibrium_constants_sym_m3, equilibrium_constants_asym_m3] = ...
  propagate_concentrations_686(o3_molecule, states, initial_concentrations_per_m3, time_s, sigma0_m2, temp_k, ...
  m_conc_per_m3, dE_j, transition_model_sym, transition_model_asym, sym_name, asym_name, optional)
% 686 wrapper for concentrations propagation
% If total concentration is propagated then transition_model_sym is used
% sym/asym name specifies name of the columns in states table to be used as the corresponding probabilities

  if nargin < nargin(@propagate_concentrations_686)
    optional = nan;
  end
  separate_propagation = get_or_default(optional, 'separate_propagation', false);

  equilibrium_constants_total_m3 = calculate_formation_decay_equilibrium_2(o3_molecule, states, temp_k, optional);
  equilibrium_constants_sym_m3 = equilibrium_constants_total_m3 .* states{:, sym_name};
  equilibrium_constants_asym_m3 = equilibrium_constants_total_m3 .* states{:, asym_name};
  if ~separate_propagation
    [concentrations_total_per_m3, derivatives_total_per_m3_s] = propagate_concentrations(o3_molecule, states, ...
      initial_concentrations_per_m3, equilibrium_constants_total_m3, time_s, sigma0_m2, temp_k, m_conc_per_m3, ...
      dE_j, transition_model_sym, optional);
    sym_mult = [states{:, sym_name}', 1, 1, 1, 1];
    asym_mult = [states{:, asym_name}', 1, 1, 1, 1];
    concentrations_sym_per_m3 = concentrations_total_per_m3 .* sym_mult;
    concentrations_asym_per_m3 = concentrations_total_per_m3 .* asym_mult;
    derivatives_sym_per_m3_s = derivatives_total_per_m3_s .* sym_mult;
    derivatives_asym_per_m3_s = derivatives_total_per_m3_s .* asym_mult;
  else
    [concentrations_sym_per_m3, derivatives_sym_per_m3_s] = propagate_concentrations(o3_molecule, states, ...
      initial_concentrations_per_m3, equilibrium_constants_sym_m3, time_s, sigma0_m2, temp_k, m_conc_per_m3, ...
      dE_j, transition_model_sym, optional);
    [concentrations_asym_per_m3, derivatives_asym_per_m3_s] = propagate_concentrations(o3_molecule, states, ...
      initial_concentrations_per_m3, equilibrium_constants_asym_m3, time_s, sigma0_m2, temp_k, m_conc_per_m3, ...
      dE_j, transition_model_asym, optional);
  end
end