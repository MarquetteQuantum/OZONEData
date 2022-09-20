function krec_m6_per_s = get_krec(concentrations_per_m3, derivatives_per_m3_s, equilibrium_constants_m3, ...
  num_reactants, channel_ind, region_ind, M_per_m3)
% Calculates krec vs time based on the results on propagation wrt to a given channel and given region
% Reactants concentrations are assumed to be in the last columns, in order of the usual channel indices (i.e. B, A)
  Keq_m3 = sum(equilibrium_constants_m3(:, channel_ind, region_ind));
  O3_per_m3 = sum(concentrations_per_m3(:, 1 : end - num_reactants, region_ind), 2);
  dO3dt_per_m3_s = sum(derivatives_per_m3_s(:, 1 : end - num_reactants, region_ind), 2);
  first_reactant_ind = size(concentrations_per_m3, 2) - num_reactants + 1 + 2*(channel_ind - 1);
  last_reactant_ind = first_reactant_ind + 1;
  reactants_per_m3 = concentrations_per_m3(:, first_reactant_ind:last_reactant_ind, region_ind);
  krec_m6_per_s = dO3dt_per_m3_s ./ (prod(reactants_per_m3, 2) - O3_per_m3 / Keq_m3) / M_per_m3;
end