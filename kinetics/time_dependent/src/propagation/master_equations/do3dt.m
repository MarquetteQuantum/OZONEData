function res = do3dt(transition_matrix_mod_m3_per_s, decay_rates_per_s, equilibrium_constants_m3, M_conc_per_m3, ...
  all_concs_per_m3)
% Evaluates O3 full concentration derivatives for given concentrations values and transition matrix
% transition_matrix_mod(i, j) has full transition rate constant from j-th to i-th state
% transition_matrix_mod(i, i) has negative sum of full transition rate constants from i-th to all other states
% decay_rates and equilibrium_constants have number of columns equal to number of distinct channels in a molecule
% all_concs is a column vector of full concentrations for all states of O3 and reactants
% Total concentrations of reactants are stored in the last 4 elements of all_concs
% in order: reactant 1, 2 of channel 1, then reactant 1, 2 of channel 2
% For 666 only channel 1 exists

  last_o3_ind = size(transition_matrix_mod_m3_per_s, 1);
  o3_per_m3 = all_concs_per_m3(1 : last_o3_ind);
  reactants_per_m3 = reshape(all_concs_per_m3(last_o3_ind + 1 : end), 2, size(decay_rates_per_s, 2));

  transition_per_m3_s = transition_matrix_mod_m3_per_s * o3_per_m3 * M_conc_per_m3;
  formation_per_m3_s = decay_rates_per_s .* equilibrium_constants_m3 .* reactants_per_m3(1, :) .* ...
    reactants_per_m3(2, :);
  decay_per_m3_s = decay_rates_per_s .* o3_per_m3;

  derivatives_per_m3_s = zeros(size(all_concs_per_m3));
  derivatives_per_m3_s(1 : last_o3_ind) = transition_per_m3_s + sum(formation_per_m3_s, 2) - sum(decay_per_m3_s, 2);
  derivatives_reactants_per_m3_s = repmat(sum(decay_per_m3_s, 1) - sum(formation_per_m3_s, 1), [2, 1]);
  derivatives_per_m3_s(last_o3_ind + 1 : end) = derivatives_reactants_per_m3_s(:);

  res = derivatives_per_m3_s;
end