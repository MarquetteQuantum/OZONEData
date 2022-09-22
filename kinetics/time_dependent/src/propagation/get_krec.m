function krec_m6_per_s = get_krec(concentrations_per_m3, derivatives_per_m3_s, equilibrium_constants_m3, M_per_m3, ...
  channel_ind)
% Calculates krec vs time based on the results on propagation
% Reactants concentrations are assumed to be in the last columns, in order of the usual channel indices (i.e. B, A)
  num_reactants = size(concentrations_per_m3, 2) - length(equilibrium_constants_m3);
  Keq_m3 = sum(equilibrium_constants_m3(:, channel_ind));
  O3_per_m3 = sum(concentrations_per_m3(:, 1 : end - num_reactants), 2);
  dO3dt_per_m3_s = sum(derivatives_per_m3_s(:, 1 : end - num_reactants), 2);
  last_reactant_ind = length(equilibrium_constants_m3) + 2*channel_ind;
  first_reactant_ind = last_reactant_ind - 1;
  reactants_per_m3 = concentrations_per_m3(:, first_reactant_ind:last_reactant_ind);
  krec_m6_per_s = dO3dt_per_m3_s ./ (prod(reactants_per_m3, 2) - O3_per_m3 / Keq_m3) / M_per_m3;
end