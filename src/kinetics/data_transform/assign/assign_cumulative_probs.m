function states = assign_cumulative_probs(states)
% Assigns cumulative probabilities over different regions
  states = assign_cov(states);
  states = assign_vdw(states);
  states = assign_sym_mol(states);
  states = assign_asym_mol(states);
end