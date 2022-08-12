function [concentrations, ode_func, flux_func, equilibrium_constants_m3] = propagate_concentrations(level, ...
  o3_molecule, states, initial_concentrations, time_s, sigma0_m2, temp_k, m_conc_per_m3, dE_j, optional)
% Propagates states' concentrations on a given time grid
% Level specifies level of theory

  transition_matrix_m3_per_s = calculate_transition_matrix(o3_molecule, temp_k, sigma0_m2, states, dE_j);
  first_unbound_ind = find(states{:, 'energy'} > 0, 1);
  flux_func = @(y) do3dt_flux(transition_matrix_m3_per_s, m_conc_per_m3, first_unbound_ind, y);

  if level == 1
    ode_func = @(t, y) do3dt_level_1(transition_matrix_m3_per_s, m_conc_per_m3, first_unbound_ind, y);
  elseif level == 2
    [equilibrium_constants_m3, threshold_energies_j] = calculate_formation_decay_equilibrium_2(...
      o3_molecule, states, temp_k, optional);
    decay_rates_per_s = get_decay_coeffs(o3_molecule, states, threshold_energies_j);
    transition_matrix_mod_m3_per_s = (transition_matrix_m3_per_s - diag(sum(transition_matrix_m3_per_s, 2)))';
    if o3_molecule == "666"
      ode_func = @(t, y) do3dt_level_2_lighter(transition_matrix_mod_m3_per_s, decay_rates_per_s, ...
        equilibrium_constants_m3, m_conc_per_m3, y);
    else
      ode_func = @(t, y) do3dt_686(transition_matrix_mod_m3_per_s, decay_rates_per_s(:, 1), decay_rates_per_s(:, 2), ...
        equilibrium_constants_m3(:, 1), equilibrium_constants_m3(:, 2), m_conc_per_m3, y);
    end
  end

  options = odeset('RelTol', 1e-13, 'AbsTol', 1e-15);
  [~, concentrations] = ode89(ode_func, time_s, initial_concentrations, options);
end