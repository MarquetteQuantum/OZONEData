function states = assign_asym_mol(states)
% Assigns total asymmetric molecule probability
  states{:, "asym_mol"} = states{:, "asym"} + states{:, "vdw_a_asym"} + states{:, "vdw_b"};
end